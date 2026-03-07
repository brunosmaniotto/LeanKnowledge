"""Prompt Tuner — learns from compilation failures to improve translator prompts.

Two layers:
  1. Static rules: known Lean 4 / Mathlib pitfalls (seeded from pilot observations).
  2. Dynamic lessons: extracted from training triples at runtime.

The tuner produces a "LESSONS LEARNED" section injected into the translator prompt,
so the LLM avoids repeating mistakes seen across the entire run.
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

class PromptTuner:
    """Learns from compilation failures and produces improved prompt sections.

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

    def ingest_triples(self, triples: list[dict]) -> None:
        """Ingest training triples from previous runs to learn patterns."""
        failed = [t for t in triples if not t.get("compiled")]
        self._error_history.extend(failed)
        self._dynamic_patterns = _extract_patterns(self._error_history)

        # Track which static rules match historical errors
        for t in failed:
            output = t.get("compiler_output", "")
            for rule in self.rules:
                if rule.pattern and re.search(rule.pattern, output):
                    self._triggered_rules[rule.id] += 1

    def ingest_triples_dir(self, triples_dir: Path) -> None:
        """Load all triple JSON files from a directory."""
        if not triples_dir.exists():
            return
        for path in sorted(triples_dir.glob("*.json")):
            data = json.loads(path.read_text(encoding="utf-8"))
            self.ingest_triples(data)

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

        return "\n".join(sections)

    @property
    def stats(self) -> dict:
        """Summary of what the tuner has learned."""
        return {
            "total_failures_ingested": len(self._error_history),
            "triggered_rules": dict(self._triggered_rules.most_common()),
            "dynamic_patterns": len(self._dynamic_patterns),
        }
