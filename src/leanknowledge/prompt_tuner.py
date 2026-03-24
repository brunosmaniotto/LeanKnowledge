"""Prompt Tuner — learns from compilation failures AND successes.

Three layers:
  1. Static rules: known Lean 4 / Mathlib pitfalls (seeded from pilot observations).
  2. Dynamic lessons: extracted from training triples at runtime.
  3. Cross-theorem learning: identifiers and tactics from successful compilations
     are injected into future prompts, so later theorems know what works.

The tuner produces a "LESSONS LEARNED" section injected into the translator prompt,
so the LLM avoids repeating mistakes and reuses proven Mathlib paths.
"""

import json
import re
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path


# ---------------------------------------------------------------------------
# Static rules — things we know trip up LLMs
# ---------------------------------------------------------------------------

@dataclass
class Rule:
    """A known pitfall with a short description and fix."""
    id: str
    pattern: str           # regex matched against compiler output
    category: str          # for grouping
    description: str       # what the user prompt should say
    priority: int = 1      # higher = more important


STATIC_RULES: list[Rule] = [
    # --- Lean 3 vs Lean 4 syntax ---
    Rule(
        id="lean3_sum_syntax",
        pattern=r"unexpected token 'in'",
        category="syntax",
        description=(
            "NEVER use Lean 3 sum syntax `∑ i in range n, f i`. "
            "Lean 4 uses `∑ i ∈ Finset.range n, f i` or `∑ i ∈ range n, f i` "
            "with `open Finset`."
        ),
        priority=10,
    ),
    Rule(
        id="lean3_prod_syntax",
        pattern=r"unexpected token 'in'.*prod|prod.*unexpected token 'in'",
        category="syntax",
        description=(
            "NEVER use Lean 3 product syntax `∏ i in s, f i`. "
            "Lean 4 uses `∏ i ∈ s, f i`."
        ),
        priority=10,
    ),

    # --- Natural number division ---
    Rule(
        id="nat_division",
        pattern=r"Nat\.div|n \* \(n \+ 1\) / 2|rewrite.*failed.*\/",
        category="arithmetic",
        description=(
            "Natural number division (ℕ) is FLOOR DIVISION — `5 / 2 = 2`, not `2.5`. "
            "This makes `n * (n+1) / 2` hard to work with directly. Strategies:\n"
            "  - Multiply both sides by the denominator to eliminate division\n"
            "  - Use `Nat.div_eq_of_eq_mul_right` or `Nat.mul_div_cancel`\n"
            "  - Cast to ℤ or ℚ, prove there, then cast back\n"
            "  - Use `2 * (∑ i ∈ range (n+1), i) = n * (n+1)` to avoid division entirely"
        ),
        priority=9,
    ),

    # --- Hallucinated identifiers ---
    Rule(
        id="hallucinated_ident",
        pattern=r"Unknown (?:constant|identifier)",
        category="identifiers",
        description=(
            "Do NOT guess Mathlib lemma names. If you're unsure whether a lemma exists:\n"
            "  - Use `exact?`, `apply?`, or `search_proof?` tactics to find it\n"
            "  - Prefer well-known lemmas: `Nat.Prime.pos`, `Finset.dvd_prod_of_mem`, etc.\n"
            "  - Check the namespace: `Nat.add_comm` not `add_comm` (or `open Nat`)\n"
            "  - Deprecated names cause errors — use current Mathlib API"
        ),
        priority=8,
    ),

    # --- Hallucinated game theory namespace ---
    Rule(
        id="no_game_theory_namespace",
        pattern=r"unknown namespace `GameTheory`|NormalFormGame|GameTheory\.",
        category="identifiers",
        description=(
            "There is NO `GameTheory` namespace or `NormalFormGame` type in Mathlib. "
            "Do not use `open GameTheory` or `NormalFormGame`. "
            "For game-theoretic statements, define the relevant types locally "
            "(e.g., `def NormalFormGame := ...`) or use basic Mathlib structures "
            "like `Finset`, `Function`, and `Matrix` directly."
        ),
        priority=9,
    ),

    # --- Monotonicity / anti-monotonicity identifier hallucination ---
    Rule(
        id="monotonicity_identifiers",
        pattern=(
            r"Invalid field.*(?:lt_iff_lt|neg_strictAnti|lt_of_lt_map_lt|gt_implies_lt|"
            r"neg_strictMono|strictAnti_neg)|"
            r"unknown namespace.*Order\.Monotone|"
            r"Unknown.*Function\.(?:lt_iff_lt|neg_strict|lt_of_lt)"
        ),
        category="identifiers",
        description=(
            "CRITICAL — Monotonicity identifiers: Do NOT use `Function.lt_iff_lt`, "
            "`Function.neg_strictAnti`, `Function.lt_of_lt_map_lt`, `Function.gt_implies_lt`, "
            "or `Order.Monotone` namespace — NONE of these exist in Mathlib.\n"
            "Correct Mathlib API for StrictMono/StrictAnti:\n"
            "  - `StrictMono.lt_iff_lt` — a < b ↔ f a < f b (for StrictMono f)\n"
            "  - `StrictAnti.lt_iff_gt` — f a < f b ↔ b < a (for StrictAnti f)\n"
            "  - `StrictMono.comp` / `StrictAnti.comp` — function composition\n"
            "  - `StrictMono.comp_strictAnti` — StrictMono ∘ StrictAnti → StrictAnti\n"
            "  - `StrictAnti.comp_strictMono` — StrictAnti ∘ StrictMono → StrictAnti\n"
            "To prove `StrictAnti (fun x => f x - g x)` from `StrictAnti f` and `StrictMono g`:\n"
            "  Use `fun a b h => by linarith [hf h, hg h]` — direct lambda + linarith.\n"
            "  There is NO `StrictAnti.sub` or `StrictMono.neg` in Mathlib."
        ),
        priority=9,
    ),

    # --- Deprecated API ---
    Rule(
        id="deprecated_api",
        pattern=r"has been deprecated",
        category="identifiers",
        description=(
            "Some Mathlib lemmas have been renamed or deprecated. "
            "If you see a deprecation warning, use the suggested replacement. "
            "Common renames: `Int.cast_natAbs` → check the deprecation message for the new name."
        ),
        priority=7,
    ),

    # --- Rewrite failures ---
    Rule(
        id="rewrite_pattern_mismatch",
        pattern=r"Tactic `rewrite` failed.*Did not find.*pattern",
        category="tactics",
        description=(
            "If `rw` fails with 'Did not find an occurrence of the pattern', "
            "the goal doesn't match the LHS of your rewrite lemma. Try:\n"
            "  - `ring_nf` or `simp` first to normalize the goal\n"
            "  - `conv` to target a specific subexpression\n"
            "  - A different lemma whose LHS matches the actual goal shape"
        ),
        priority=6,
    ),

    # --- Object file missing ---
    Rule(
        id="missing_olean",
        pattern=r"object file.*does not exist",
        category="imports",
        description=(
            "If you get 'object file does not exist', your import path is wrong. "
            "Use `import Mathlib` (imports everything) rather than guessing specific module paths. "
            "Specific imports like `import Mathlib.Data.Nat.Prime.Basic` may be stale."
        ),
        priority=8,
    ),

    # --- Empty code ---
    Rule(
        id="empty_code",
        pattern=r"empty or vacuous code",
        category="output",
        description=(
            "You MUST produce a complete theorem/lemma/def declaration. "
            "Do NOT output empty text, comments only, or just imports. "
            "Always include at least one `theorem`, `lemma`, or `def`."
        ),
        priority=10,
    ),

    # --- General Lean 4 tips ---
    Rule(
        id="general_lean4",
        pattern="",  # always included
        category="general",
        description=(
            "Key Lean 4 / Mathlib conventions:\n"
            "  - `import Mathlib` imports everything (safe default)\n"
            "  - Use `open BigOperators` for `∑` and `∏` notation\n"
            "  - Use `open Finset` for `range`, `sum`, `prod`\n"
            "  - Prefer `omega` for linear arithmetic on ℕ/ℤ\n"
            "  - Prefer `norm_num` for concrete numeric goals\n"
            "  - Prefer `simp [lemma1, lemma2]` with explicit lemmas over bare `simp`\n"
            "  - Use `exact?` when you know a lemma should close the goal"
        ),
        priority=5,
    ),

    # --- Hallucinated identifiers ---
    Rule(
        id="no_invented_identifiers",
        pattern=r"Unknown identifier|Unknown constant",
        category="identifiers",
        description=(
            "Do NOT invent custom identifier names that don't exist in Mathlib. "
            "If you need a concept that isn't in Mathlib, define it locally with "
            "`def` or `structure` in your code, or use `axiom` to stub it. "
            "Never reference identifiers like `InvariantToCommonCardinalTransformations` "
            "or `IsConvex` (use `Convex ℝ` instead) without defining them first."
        ),
        priority=8,
    ),

    # --- Noncomputable definitions ---
    Rule(
        id="noncomputable_real",
        pattern=r"dependsOnNoncomputable|noncomputable",
        category="syntax",
        description=(
            "When defining functions that use ℝ (Real) operations like division, "
            "sqrt, or trigonometric functions, mark the definition as `noncomputable`. "
            "Example: `noncomputable def f (x : ℝ) : ℝ := x / 2`"
        ),
        priority=8,
    ),
]


# ---------------------------------------------------------------------------
# Dynamic lesson extraction
# ---------------------------------------------------------------------------

@dataclass
class ErrorPattern:
    """A pattern observed across multiple compilation failures."""
    description: str
    count: int
    example_error: str
    example_code_snippet: str = ""


def _extract_patterns(triples: list[dict]) -> list[ErrorPattern]:
    """Analyze triples and extract recurring error patterns."""
    if not triples:
        return []

    error_messages = []
    for t in triples:
        if not t.get("compiled") and t.get("compiler_output"):
            error_messages.append({
                "output": t["compiler_output"],
                "code": t.get("lean_code", ""),
            })

    if not error_messages:
        return []

    # Bucket errors by their core message (strip file paths and line numbers)
    buckets: dict[str, list[dict]] = {}
    for err in error_messages:
        # Normalize: strip path prefix and line/col numbers
        core = re.sub(
            r"/[^\s:]+\.lean:\d+:\d+:\s*",
            "",
            err["output"],
        )
        # Take first line as key
        key = core.strip().split("\n")[0][:120]
        buckets.setdefault(key, []).append(err)

    patterns = []
    for key, instances in sorted(buckets.items(), key=lambda x: -len(x[1])):
        if len(instances) < 2:
            continue  # only report patterns seen multiple times
        patterns.append(ErrorPattern(
            description=key,
            count=len(instances),
            example_error=instances[0]["output"][:200],
            example_code_snippet=instances[0]["code"][:150] if instances[0]["code"] else "",
        ))

    return patterns


# ---------------------------------------------------------------------------
# Prompt Tuner
# ---------------------------------------------------------------------------

def _extract_identifiers(lean_code: str) -> set[str]:
    """Extract Mathlib identifiers from compiled Lean code.

    Looks for qualified names (Namespace.name) that are likely Mathlib
    references. Filters out common non-Mathlib patterns.
    """
    if not lean_code:
        return set()

    # Match qualified identifiers: Capitalized.word patterns (e.g., Nat.add_comm)
    qualified = re.findall(r'\b([A-Z][a-zA-Z0-9]*(?:\.[a-zA-Z_][a-zA-Z0-9_]*)+)\b', lean_code)

    # Filter out noise
    noise = {
        "Mathlib", "BigOperators", "Finset", "Nat", "Int", "Real", "Set",
        "List", "Type", "Prop", "Sort",
    }
    result = set()
    for ident in qualified:
        # Skip bare namespace opens and imports
        if ident.startswith("Mathlib."):
            continue
        # Skip if it's just a single namespace name
        parts = ident.split(".")
        if len(parts) < 2:
            continue
        # Skip if the last part is a type variable or very short
        if len(parts[-1]) <= 1:
            continue
        # Skip Scratch file references
        if "Scratch" in ident:
            continue
        result.add(ident)

    # Also extract standalone tactics that compiled successfully
    tactic_pattern = re.findall(
        r'\b(omega|ring|norm_num|linarith|positivity|field_simp|gcongr|'
        r'push_neg|contrapose|absurd|exact\?|apply\?)\b',
        lean_code,
    )

    return result | set(tactic_pattern)


class PromptTuner:
    """Learns from compilation failures AND successes.

    Three layers:
      1. Static rules (known pitfalls)
      2. Dynamic error patterns (recurring mistakes)
      3. Cross-theorem learning (confirmed identifiers from successes)

    Usage:
        tuner = PromptTuner()
        tuner.ingest_triples(triples_from_previous_runs)

        # In the translator:
        lessons = tuner.get_lessons(current_errors)
        prompt = base_prompt + lessons
    """

    def __init__(self, rules: list[Rule] | None = None):
        self.rules = rules or list(STATIC_RULES)
        self._error_history: list[dict] = []
        self._triggered_rules: Counter = Counter()
        self._dynamic_patterns: list[ErrorPattern] = []
        # Cross-theorem learning: identifiers confirmed to compile
        self._confirmed_identifiers: Counter = Counter()
        # Cross-theorem failure lessons from FailureAnalyst
        self._failure_lessons: list[dict] = []  # [{cluster_id, severity, lesson_text}]

    def ingest_triples(self, triples: list[dict]) -> None:
        """Ingest training triples — learn from both failures and successes."""
        failed = [t for t in triples if not t.get("compiled")]
        self._error_history.extend(failed)
        self._dynamic_patterns = _extract_patterns(self._error_history)

        # Track which static rules match historical errors
        for t in failed:
            output = t.get("compiler_output", "")
            for rule in self.rules:
                if rule.pattern and re.search(rule.pattern, output):
                    self._triggered_rules[rule.id] += 1

        # Cross-theorem learning: extract identifiers from successes
        for t in triples:
            if t.get("compiled") and t.get("lean_code"):
                idents = _extract_identifiers(t["lean_code"])
                self._confirmed_identifiers.update(idents)

    def ingest_triples_dir(self, triples_dir: Path) -> None:
        """Load all triple JSON files from a directory."""
        if not triples_dir.exists():
            return
        for path in sorted(triples_dir.glob("*.json")):
            data = json.loads(path.read_text(encoding="utf-8"))
            self.ingest_triples(data)

    def add_failure_lessons(self, lessons: list) -> None:
        """Add cross-theorem failure lessons from FailureAnalyst.

        Args:
            lessons: list of FailureLesson objects (or dicts with
                cluster_id, severity, lesson_text keys).
        """
        for lesson in lessons:
            if hasattr(lesson, "cluster_id"):
                # FailureLesson dataclass
                self._failure_lessons.append({
                    "cluster_id": lesson.cluster_id,
                    "severity": lesson.severity,
                    "lesson_text": lesson.lesson_text,
                })
            else:
                # Already a dict
                self._failure_lessons.append(lesson)

    def save_failure_lessons(self, path: Path) -> None:
        """Persist failure lessons to JSON for cross-cycle use."""
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(self._failure_lessons, indent=2), encoding="utf-8")

    def load_failure_lessons(self, path: Path) -> None:
        """Load failure lessons from a previous cycle."""
        if not path.exists():
            return
        data = json.loads(path.read_text(encoding="utf-8"))
        self._failure_lessons.extend(data)

    def save_identifiers(self, path: Path) -> None:
        """Persist confirmed identifiers to JSON for cross-run learning."""
        path.parent.mkdir(parents=True, exist_ok=True)
        data = dict(self._confirmed_identifiers.most_common())
        path.write_text(json.dumps(data, indent=2), encoding="utf-8")

    def load_identifiers(self, path: Path) -> None:
        """Load confirmed identifiers from a previous run."""
        if not path.exists():
            return
        data = json.loads(path.read_text(encoding="utf-8"))
        self._confirmed_identifiers.update(data)

    def get_lessons(self, current_errors: list[str] | None = None) -> str:
        """Build a LESSONS LEARNED section for the translator prompt.

        Args:
            current_errors: compiler errors from current theorem's attempts
                (prioritizes rules matching these specific errors)

        Returns:
            Formatted text to inject into the translator prompt.
        """
        # Collect applicable rules
        applicable: list[tuple[int, Rule]] = []

        for rule in self.rules:
            priority = rule.priority

            # Boost priority if this rule was triggered in history
            if rule.id in self._triggered_rules:
                priority += min(self._triggered_rules[rule.id], 5)

            # Boost further if current errors match
            if current_errors and rule.pattern:
                for err in current_errors:
                    if re.search(rule.pattern, err):
                        priority += 10
                        break

            # Always include general rules, only include pattern rules if relevant
            if not rule.pattern:
                applicable.append((priority, rule))
            elif rule.id in self._triggered_rules:
                applicable.append((priority, rule))
            elif current_errors and rule.pattern:
                for err in current_errors:
                    if re.search(rule.pattern, err):
                        applicable.append((priority, rule))
                        break

        # Sort by priority (highest first)
        applicable.sort(key=lambda x: -x[0])

        # Build the output
        sections = []
        sections.append("## CRITICAL: Known pitfalls — DO NOT repeat these mistakes\n")

        for _priority, rule in applicable:
            sections.append(f"### {rule.category.upper()}: {rule.id}")
            sections.append(rule.description)
            if rule.id in self._triggered_rules:
                count = self._triggered_rules[rule.id]
                sections.append(f"(This mistake was seen {count} time(s) in this run.)\n")
            else:
                sections.append("")

        # Add dynamic patterns if we have them
        if self._dynamic_patterns:
            sections.append("\n## Recurring errors in this batch\n")
            for pat in self._dynamic_patterns[:5]:  # top 5
                sections.append(
                    f"- **{pat.count}× seen**: {pat.description}"
                )

        # Cross-theorem learning: confirmed identifiers from earlier successes
        if self._confirmed_identifiers:
            # Show top identifiers by frequency (most-used = most reliable)
            top = self._confirmed_identifiers.most_common(30)
            ident_list = ", ".join(f"`{name}`" for name, _ in top)
            sections.append(
                f"\n## Confirmed Mathlib identifiers (from {sum(self._confirmed_identifiers.values())} "
                f"uses in earlier successful proofs)\n"
                f"These identifiers compiled successfully — prefer them over guessing:\n"
                f"{ident_list}"
            )

        # Cross-theorem failure analysis lessons (from FailureAnalyst)
        if self._failure_lessons:
            sections.append(
                "\n## Cross-theorem failure analysis "
                f"({len(self._failure_lessons)} lesson(s) from batch diagnostics)\n"
            )
            for lesson in self._failure_lessons:
                severity = lesson.get("severity", "medium").upper()
                cluster_id = lesson.get("cluster_id", "unknown")
                sections.append(f"### [{severity}] {cluster_id}")
                sections.append(lesson.get("lesson_text", ""))
                sections.append("")

        return "\n".join(sections)

    @property
    def stats(self) -> dict:
        """Summary of what the tuner has learned."""
        return {
            "total_failures_ingested": len(self._error_history),
            "triggered_rules": dict(self._triggered_rules.most_common()),
            "dynamic_patterns": len(self._dynamic_patterns),
            "confirmed_identifiers": len(self._confirmed_identifiers),
            "failure_lessons": len(self._failure_lessons),
        }


def merge_identifier_files(paths: list[Path], output_path: Path) -> int:
    """Merge multiple confirmed_identifiers.json files into one.

    Each file is a JSON dict of {identifier: count}. Counts are summed
    across all files. Use this to warm-start a new run with identifiers
    confirmed across multiple workers in a previous run.

    Returns the total number of unique identifiers in the merged file.
    """
    merged: Counter = Counter()
    for path in paths:
        if not path.exists():
            continue
        data = json.loads(path.read_text(encoding="utf-8"))
        merged.update(data)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(dict(merged.most_common()), indent=2),
        encoding="utf-8",
    )
    return len(merged)
