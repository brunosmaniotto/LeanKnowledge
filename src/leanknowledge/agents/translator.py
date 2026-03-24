"""Agent 6: Translator — converts theorems into Lean 4 code.

Two-phase translation:
  Phase 1 (Direct): Skip Agent 5. Give the model just the theorem
    statement + any NL proof. This leverages the model's own mathematical
    knowledge — analogous to asking in a browser.
  Phase 2 (Guided): If direct fails, escalate through tiers with
    full history of all prior attempts.

Three-tier escalation: DeepSeek → Gemini → Decompose.
Budget: 3 direct + 7 tier1 (DeepSeek) + 5 tier2 (Gemini) + 1 decomposition = 16 max.
Each attempt carries the FULL history of all previous attempts (including
direct-phase failures), as compact summaries for older ones and full code
for the most recent.

Oracle tier (optional, disabled by default):
  After all 16 standard attempts fail, an oracle model (default: Claude Sonnet)
  analyzes ALL prior failure triples, performs root-cause analysis, and tries
  a fundamentally different approach. Budget: 5 additional attempts (configurable).
  Enable with LK_TRANSLATOR_ORACLE_ENABLED=1.

Training data collection:
  Every attempt produces a triple:
    (structured_proof, lean_code, compiler_output, reasoning)
  These triples train both the translator (RL) and the structurer.
"""

import difflib
import os
import re
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path

import logging

from ..schemas import StructuredProof, ProofStrategy, ExtractedItem
from ..llm import complete, complete_json, MODEL_FAST_B, MODEL_HEAVY, LLMInfraError
from ..knowledge_graph import StrategyKB
from ..lean.pre_compiler import PreCompiler
from ..loogle import LoogleClient, LoogleResult
from ..mathlib_index import MathlibIndex, SearchResult
from ..prompt_tuner import PromptTuner

_logger = logging.getLogger(__name__)

# Temperature for retries — adds diversity when the model is stuck
RETRY_TEMPERATURE = float(os.environ.get("LK_TRANSLATOR_RETRY_TEMP", "0.6"))

# Per-tier CLI timeouts (seconds) — longer tiers get more time
# Direct phase has short prompts; guided tiers have history; Tier 3 is complex
DIRECT_CLI_TIMEOUT = int(os.environ.get("LK_TRANSLATOR_DIRECT_CLI_TIMEOUT", "300"))
TIER1_CLI_TIMEOUT = int(os.environ.get("LK_TRANSLATOR_TIER1_CLI_TIMEOUT", "600"))
TIER2_CLI_TIMEOUT = int(os.environ.get("LK_TRANSLATOR_TIER2_CLI_TIMEOUT", "900"))
TIER3_CLI_TIMEOUT = int(os.environ.get("LK_TRANSLATOR_TIER3_CLI_TIMEOUT", "1200"))

# Loogle integration — enabled by default (free API)
LOOGLE_ENABLED = os.environ.get("LK_LOOGLE_ENABLED", "1") == "1"

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "translator.md"
DECOMPOSER_PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "decomposer.md"
DEFINITION_PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "definition_translator.md"
CATEGORY_PROMPTS_DIR = Path(__file__).resolve().parents[3] / "prompts" / "categories"

# Three-tier escalation: DeepSeek → DeepSeek → Gemini
# Each tier carries the full history of all previous attempts.
# Budget: 3 direct + 7 tier1 + 5 tier2 + 1 decomposition = 16 max
MAX_ATTEMPTS_TIER1 = int(os.environ.get("LK_TRANSLATOR_TIER1_ATTEMPTS", "7"))
MAX_ATTEMPTS_TIER2 = int(os.environ.get("LK_TRANSLATOR_TIER2_ATTEMPTS", "5"))

TIER1_MODEL = os.environ.get("LK_TRANSLATOR_TIER1_MODEL", "deepseek/deepseek-reasoner")  # DeepSeek
TIER2_MODEL = os.environ.get("LK_TRANSLATOR_TIER2_MODEL", "gemini/gemini-2.5-pro")  # Gemini (escalation)

# Max output tokens per tier
TIER1_MAX_TOKENS = int(os.environ.get("LK_TRANSLATOR_TIER1_MAX_TOKENS", "16384"))
TIER2_MAX_TOKENS = int(os.environ.get("LK_TRANSLATOR_TIER2_MAX_TOKENS", "8192"))

# Direct phase: try without Agent 5's structured proof plan
MAX_DIRECT_ATTEMPTS = int(os.environ.get("LK_TRANSLATOR_DIRECT_ATTEMPTS", "3"))
DIRECT_MODEL = os.environ.get("LK_TRANSLATOR_DIRECT_MODEL", TIER1_MODEL)  # DeepSeek
DIRECT_MAX_TOKENS = int(os.environ.get("LK_TRANSLATOR_DIRECT_MAX_TOKENS", "16384"))

# Tier 3 (hard theorem path): decompose into sub-lemmas
TIER3_ENABLED = os.environ.get("LK_TRANSLATOR_TIER3_ENABLED", "1") == "1"
TIER3_MODEL = os.environ.get("LK_TRANSLATOR_TIER3_MODEL", "gemini/gemini-2.5-pro")  # decomposer
TIER3_PROVER_MODEL = os.environ.get("LK_TRANSLATOR_TIER3_PROVER", TIER2_MODEL)  # assembly prover
TIER3_ATTEMPTS_PER_LEMMA = int(os.environ.get("LK_TRANSLATOR_TIER3_ATTEMPTS", "3"))
TIER3_MAX_TOKENS = int(os.environ.get("LK_TRANSLATOR_TIER3_MAX_TOKENS", "8192"))

# Oracle tier (post-pipeline last resort for hard theorems)
ORACLE_ENABLED = os.environ.get("LK_TRANSLATOR_ORACLE_ENABLED", "0") == "1"
ORACLE_MODEL = os.environ.get("LK_TRANSLATOR_ORACLE_MODEL", "anthropic/claude-sonnet-4-20250514")
ORACLE_MAX_ATTEMPTS = int(os.environ.get("LK_TRANSLATOR_ORACLE_ATTEMPTS", "5"))
ORACLE_MAX_TOKENS = int(os.environ.get("LK_TRANSLATOR_ORACLE_MAX_TOKENS", "16384"))

# Definition formalization: simpler budget than theorems
DEFINITION_MAX_ATTEMPTS = int(os.environ.get("LK_DEFINITION_MAX_ATTEMPTS", "6"))
DEFINITION_MODEL = os.environ.get("LK_DEFINITION_MODEL", TIER1_MODEL)
DEFINITION_ESCALATION_MODEL = os.environ.get("LK_DEFINITION_ESCALATION_MODEL", TIER2_MODEL)
DEFINITION_MAX_TOKENS = int(os.environ.get("LK_DEFINITION_MAX_TOKENS", "8192"))


# ---------------------------------------------------------------------------
# Training triple
# ---------------------------------------------------------------------------

@dataclass
class TranslationTriple:
    """One attempt: structured proof → lean code → compiler output.

    Training data for both the translator (RL) and the structurer.
    """
    structured_proof: StructuredProof
    lean_code: str
    compiler_output: str       # full compiler message (error or success)
    compiled: bool             # convenience flag
    model: str                 # which model produced this attempt
    attempt_number: int        # 1-indexed within the current tier
    reasoning: str = ""        # model's stated approach (for compact history)


class TranslationOutcome(str, Enum):
    SUCCESS = "success"
    DEFINITION_SUCCESS = "definition_success"  # definition formalized successfully
    ORACLE_SUCCESS = "oracle_success"  # solved by oracle tier after all standard tiers failed
    DECOMPOSED = "decomposed"        # assembly verified with axioms, sub-lemmas in backlog
    TARGET_AXIOMATIZED = "target_axiomatized"  # compiled but target was axiomatized, not proved
    FAILED_TIER1 = "failed_tier1"    # exhausted DeepSeek guided attempts
    FAILED_TIER2 = "failed_tier2"    # exhausted Sonnet attempts
    NEEDS_HUMAN = "needs_human"       # all tiers exhausted


class AttemptOutcome(str, Enum):
    """Classify a single compilation failure as genuine or operational.

    GENUINE: the model's proof logic is wrong (type mismatch, unsolved goals, etc.)
    OPERATIONAL: infrastructure / truncation issue, not a real proof failure
    """
    GENUINE = "genuine"
    OPERATIONAL = "operational"


def classify_attempt_outcome(compiler_output: str, lean_code: str) -> AttemptOutcome:
    """Classify whether a failed attempt is a genuine proof error or operational.

    Operational failures should not count against the attempt budget because
    they don't reflect the model's proof ability.
    """
    # Empty or whitespace code — model produced nothing useful
    if not lean_code or not lean_code.strip():
        return AttemptOutcome.OPERATIONAL

    out_lower = compiler_output.lower() if compiler_output else ""

    # Vacuous code (our own synthetic error)
    if "empty or vacuous code" in out_lower:
        return AttemptOutcome.OPERATIONAL

    # Truncated output — model ran out of tokens mid-proof
    if "unexpected end of input" in out_lower:
        return AttemptOutcome.OPERATIONAL

    # Missing .olean / unknown module — pre-compiler or environment issue
    if re.search(r"object file.*does not exist", out_lower):
        return AttemptOutcome.OPERATIONAL
    if "unknown module prefix" in out_lower:
        return AttemptOutcome.OPERATIONAL

    # Compilation timed out — environment issue
    if "compilation timed out" in out_lower:
        return AttemptOutcome.OPERATIONAL

    return AttemptOutcome.GENUINE


# ---------------------------------------------------------------------------
# Post-compilation proof validation
# ---------------------------------------------------------------------------

def _normalize_lean_name(name: str) -> str:
    """Normalize an identifier for fuzzy matching.

    Strips non-alphanumeric characters and lowercases so that
    'Claim_11E_d', 'claim_11e_d', 'Claim 11E d' all match.
    """
    return re.sub(r'[^a-z0-9]', '', name.lower())


def _extract_declarations(lean_code: str) -> list[tuple[str, str, str]]:
    """Extract top-level declarations from Lean code.

    Returns a list of (keyword, name, rest_of_line) tuples, e.g.:
        [("theorem", "my_thm", ": True := trivial"), ("axiom", "dep1", ": SomeType")]

    Skips declarations inside block comments.
    """
    # Strip block comments first (supports nesting)
    stripped = lean_code
    result_chars: list[str] = []
    depth = 0
    i = 0
    while i < len(stripped):
        if i < len(stripped) - 1 and stripped[i:i+2] == "/-":
            depth += 1
            i += 2
        elif i < len(stripped) - 1 and stripped[i:i+2] == "-/":
            depth = max(0, depth - 1)
            i += 2
        elif depth == 0:
            result_chars.append(stripped[i])
            i += 1
        else:
            i += 1
    clean = "".join(result_chars)

    # Strip line comments
    lines = []
    for line in clean.split("\n"):
        comment_pos = line.find("--")
        if comment_pos >= 0:
            line = line[:comment_pos]
        lines.append(line)
    clean = "\n".join(lines)

    decls: list[tuple[str, str, str]] = []
    # Capture keyword, name, and the rest of the line (for type detection)
    pattern = re.compile(
        r'^[ \t]*(?:noncomputable\s+|protected\s+|private\s+)*'
        r'(theorem|lemma|def|axiom|structure|class|instance|abbrev)\s+'
        r'(\S+)'
        r'(.*)',
        re.MULTILINE,
    )
    for m in pattern.finditer(clean):
        keyword = m.group(1)
        name = m.group(2).rstrip(" :{(")
        rest = m.group(3).strip()
        decls.append((keyword, name, rest))
    return decls


def _is_vacuous_type(rest_of_line: str) -> bool:
    """Check if a declaration's type signature is vacuous (True, Prop, etc.).

    Detects patterns like:
        : True := trivial
        : True := True.intro
        : Prop := True
    """
    # Strip leading colon/whitespace to get to the type
    s = rest_of_line.strip().lstrip(":").strip()
    # Check if the type starts with True or is just Prop
    # Handle: "True := trivial", "True :=", "True", "Prop"
    type_part = s.split(":=")[0].strip() if ":=" in s else s.split("by")[0].strip() if " by " in s or s.endswith(" by") else s
    type_part = type_part.strip()
    return type_part in ("True", "Prop")


def validate_proof_output(
    lean_code: str,
    item: ExtractedItem,
    is_definition: bool = False,
) -> tuple[bool, str]:
    """Validate that compiled Lean code actually proves the target item.

    Returns (valid, error_message). If valid is False, the code should be
    treated as a failed attempt — the model axiomatized the target or
    produced a dummy wrapper instead of a real proof.

    Rules:
      - For theorems: item.id must appear as a `theorem` or `lemma`,
        NOT as an `axiom`.
      - For definitions: item.id must appear as `def`, `structure`,
        `class`, `instance`, or `abbrev`, NOT as an `axiom`.
      - Dependency axioms (names that don't match item.id) are allowed.
      - A file with ONLY axioms and no matching target declaration fails.
    """
    if not lean_code:
        return False, "empty code"

    decls = _extract_declarations(lean_code)
    if not decls:
        return False, "no declarations found in code"

    target_norm = _normalize_lean_name(item.id)

    # What counts as a valid target declaration?
    if is_definition:
        valid_keywords = {"def", "structure", "class", "instance", "abbrev"}
    else:
        valid_keywords = {"theorem", "lemma"}

    # Check if any declaration matches the target name with a valid keyword
    target_found_valid = False
    target_found_axiom = False
    target_is_vacuous = False

    for keyword, name, rest in decls:
        name_norm = _normalize_lean_name(name)
        if name_norm == target_norm or target_norm in name_norm or name_norm in target_norm:
            if keyword in valid_keywords:
                target_found_valid = True
                # Check for vacuous proofs: `theorem X : True` or `theorem X : Prop`
                if keyword in ("theorem", "lemma") and _is_vacuous_type(rest):
                    target_is_vacuous = True
            elif keyword == "axiom":
                target_found_axiom = True

    if target_found_valid and target_is_vacuous:
        return False, (
            f"target '{item.id}' has a vacuous proof (type is True/Prop). "
            f"The theorem must prove the actual statement, not `True`."
        )

    if target_found_valid:
        return True, ""

    if target_found_axiom:
        return False, (
            f"target '{item.id}' is axiomatized, not proved. "
            f"The target must appear as a {'/'.join(sorted(valid_keywords))} "
            f"declaration, not as an axiom."
        )

    # Target not found at all — check if there's at least one valid declaration
    # (the model may have used a different name)
    has_any_valid = any(kw in valid_keywords for kw, _, _ in decls)
    has_only_axioms = all(kw == "axiom" for kw, _, _ in decls)

    if has_only_axioms:
        return False, (
            f"code contains only axiom declarations — no real proof. "
            f"Expected a {'/'.join(sorted(valid_keywords))} declaration "
            f"for '{item.id}'."
        )

    if has_any_valid:
        # Model used a different name but did prove something.
        # Check that it's not ALL vacuous.
        all_vacuous = all(
            _is_vacuous_type(rest)
            for kw, _, rest in decls
            if kw in valid_keywords
        )
        if all_vacuous:
            return False, (
                f"all {'/'.join(sorted(valid_keywords))} declarations are vacuous "
                f"(type is True). No real proof found for '{item.id}'."
            )
        return True, ""

    return False, (
        f"no {'/'.join(sorted(valid_keywords))} declaration found for "
        f"'{item.id}'. Code only contains: "
        f"{', '.join(kw + ' ' + n for kw, n, _ in decls[:5])}"
    )


# Maximum number of operational retries before counting them as genuine
MAX_OPERATIONAL_RETRIES = 3


@dataclass
class TranslationResult:
    """Full result of translating a structured proof."""
    outcome: TranslationOutcome
    lean_code: str | None = None             # final successful code (or last attempt)
    triples: list[TranslationTriple] = field(default_factory=list)
    total_attempts: int = 0
    sub_lemmas: list['SubLemma'] | None = None  # populated when outcome == DECOMPOSED
    oracle_analysis: str | None = None       # populated when outcome == ORACLE_SUCCESS

    @property
    def successful_triple(self) -> TranslationTriple | None:
        for t in self.triples:
            if t.compiled:
                return t
        return None


# ---------------------------------------------------------------------------
# Lean compiler interface (pluggable)
# ---------------------------------------------------------------------------

class LeanCompiler:
    """Interface for compiling Lean 4 code.

    Subclass for real compiler integration.
    """

    def compile(self, code: str) -> tuple[bool, str]:
        """Compile Lean code. Returns (success, compiler_output)."""
        raise NotImplementedError


# ---------------------------------------------------------------------------
# Direct-mode prompts (no Agent 5)
# ---------------------------------------------------------------------------

_DIRECT_SYSTEM = """\
You are a Lean 4 expert. Produce valid Lean 4 code that compiles against Mathlib.

## Rules
- Start with `import Mathlib`
- Prefer short proofs. If a Mathlib lemma solves it directly, use it.
- Use `by` tactic blocks. Use `simp`, `norm_num`, `omega`, `linarith` for arithmetic.
- Do NOT guess Mathlib lemma names — if unsure, use `exact?` or `apply?`.
- Use Lean 4 syntax (not Lean 3): `∑ i ∈ Finset.range n, f i`, not `∑ i in range n, f i`.
- For ℕ division, cast to ℤ/ℚ or reformulate to avoid floor division.
- You MUST produce a `theorem`, `lemma`, or `def` declaration.

## Type coercion (CRITICAL — many failures come from type mismatches)
- Pick ONE type (ℕ, ℤ, ℝ) and stay in it. Cast everything at the start.
- Use `↑` or `(· : TargetType)` for explicit casts: `(↑n : ℝ)`, `(n : ℤ)`
- `push_cast` pushes casts inward through arithmetic. `norm_cast` normalizes cast expressions.
- `exact_mod_cast h` applies `h` modulo cast normalization.
- WRONG: `(↑(n / 2) : ℝ)` — casts the floor result. RIGHT: `(↑n : ℝ) / 2` — cast first.
- Key lemmas: `Nat.cast_add`, `Nat.cast_mul`, `Nat.cast_succ`, `Int.cast_add`

## Mathlib naming conventions (CRITICAL)
Names follow `Namespace.property_args`. Examples: `Nat.add_comm`, `List.map_cons`.
- `_of_` means "given that", `_iff_` for biconditionals
- NO `Nat.triangular`, `Nat.fibonacci`, `Nat.isPrime`, `Nat.isEven`, `Nat.sum_range`
- Use `Nat.Prime` (Prop), `Even n`, `Odd n`, `Irrational (Real.sqrt 2)`
- Sums: `Finset.sum (Finset.range n) f`, key lemma: `Finset.sum_range_succ`
- Power tactics: `ring`, `omega`, `norm_num`, `simp`, `linarith`, `field_simp`, `positivity`
- On "Unknown constant": do NOT try minor name variations. Use `exact?`/`apply?` or rethink the approach.
"""


# ---------------------------------------------------------------------------
# Category detection + domain-specific prompt supplements
# ---------------------------------------------------------------------------

# Maps category keywords (lowercased) to supplement filenames.
# Order matters: first match wins.  Checked against both the item's
# ``section`` field and the statement text.
_CATEGORY_MAP: list[tuple[list[str], str]] = [
    # High-priority: worst performing categories
    (["probability", "measure theory", "measure_theory"], "probability.md"),
    (["trigonometry", "trigonometric"], "trigonometry.md"),
    (["geometry", "geometric", "euclidean"], "geometry.md"),
    # Good-performing but still benefit from hints
    (["number theory", "number_theory", "prime", "divisibility",
      "modular arithmetic"], "number_theory.md"),
    (["combinatorics", "counting", "binomial", "pigeonhole"], "combinatorics.md"),
    (["linear algebra", "linear_algebra", "matrix", "matrices",
      "vector space", "determinant"], "linear_algebra.md"),
    (["group theory", "group_theory", "subgroup", "homomorphism",
      "symmetric group", "abelian"], "group_theory.md"),
    (["topology", "topological", "compact", "hausdorff",
      "connected", "continuous map"], "topology.md"),
    (["real analysis", "calculus", "limit", "derivative",
      "convergence", "sequence", "series"], "analysis.md"),
    (["set theory", "set_theory"], "set_theory.md"),
    (["algebra", "polynomial", "ring theory", "field theory"], "algebra.md"),
    (["logic", "propositional", "predicate", "boolean"], "logic.md"),
    (["order theory", "lattice", "partial order", "poset"], "order_theory.md"),
]

# Secondary keyword patterns matched against the theorem statement text.
# These catch cases where the section field is generic (e.g., "Uncategorized")
# but the statement itself reveals the domain.
_STATEMENT_KEYWORDS: list[tuple[list[str], str]] = [
    (["probability", "random variable", "expectation", "σ-algebra",
      "measurable", "measure space", "P(", "Pr("], "probability.md"),
    (["sin", "cos", "tan", "arcsin", "arccos", "arctan",
      "trigonometric"], "trigonometry.md"),
    (["triangle", "angle", "perpendicular", "parallel", "midpoint",
      "circumscri", "inscri", "polygon", "circle",
      "euclidean"], "geometry.md"),
    (["prime", "divides", "divisib", "gcd", "lcm", "coprime",
      "modular", "congruent", "mod ", "≡"], "number_theory.md"),
    (["choose", "binomial", "factorial", "permutation",
      "pigeonhole", "combinat"], "combinatorics.md"),
    (["matrix", "matrices", "determinant", "rank", "eigenvalue",
      "linear map", "vector space", "subspace",
      "linearly independent"], "linear_algebra.md"),
    (["group", "subgroup", "homomorphism", "coset", "normal subgroup",
      "quotient group", "abelian", "cyclic group"], "group_theory.md"),
    (["open set", "closed set", "compact", "hausdorff", "connected",
      "homeomorph", "topolog"], "topology.md"),
    (["limit", "converge", "derivative", "integral", "continuous",
      "differentiab", "tendsto", "series", "∫"], "analysis.md"),
    (["∈", "⊆", "∪", "∩", "subset", "superset",
      "set difference"], "set_theory.md"),
    (["polynomial", "ring", "field", "ideal", "∑", "∏",
      "induction"], "algebra.md"),
    (["¬", "∧", "∨", "→", "↔", "∀", "∃",
      "contrapositive", "contradiction"], "logic.md"),
]


def detect_math_category(item: ExtractedItem) -> str | None:
    """Detect the mathematical domain of an item.

    Checks the item's ``section`` field first (high confidence — comes from
    dataset metadata like ProofWiki categories), then falls back to keyword
    matching on the statement text.

    Returns:
        Filename of the matching category supplement (e.g. "probability.md"),
        or None if no category matched.
    """
    section_lower = (item.section or "").lower()
    statement_lower = (item.statement or "").lower()

    # Pass 1: match against section field (high confidence)
    for keywords, filename in _CATEGORY_MAP:
        for kw in keywords:
            if kw in section_lower:
                return filename

    # Pass 2: match against statement text (lower confidence, stricter keywords)
    for keywords, filename in _STATEMENT_KEYWORDS:
        matches = sum(1 for kw in keywords if kw in statement_lower)
        if matches >= 2:
            return filename

    # Pass 3: single strong keyword in statement
    for keywords, filename in _STATEMENT_KEYWORDS:
        for kw in keywords:
            if kw in statement_lower and len(kw) >= 6:
                return filename

    return None


def _load_category_supplement(category_file: str | None) -> str:
    """Load a category-specific prompt supplement.

    Args:
        category_file: filename like "probability.md", or None.

    Returns:
        The supplement text, or empty string if no file / not found.
    """
    if not category_file:
        return ""
    path = CATEGORY_PROMPTS_DIR / category_file
    if path.exists():
        return path.read_text(encoding="utf-8")
    return ""


def _minimal_proof(item: ExtractedItem) -> StructuredProof:
    """Create a minimal StructuredProof for direct attempts (no steps).

    Used so that direct-phase triples share the same data contract as
    guided-phase triples. Direct attempts are identifiable by steps == [].
    """
    return StructuredProof(
        theorem_name=item.id,
        strategy=ProofStrategy.DIRECT,
        goal_statement=item.statement,
        conclusion=item.statement,
    )


def _extract_unknown_identifiers(compiler_output: str) -> list[str]:
    """Extract unknown identifier/constant names from compiler errors.

    Finds patterns like:
      - Unknown constant `Foo.bar_baz`
      - Unknown identifier `xyz`
      - unknown module prefix 'abc'
    """
    patterns = [
        re.compile(r"Unknown constant [`'](\S+?)[`']"),
        re.compile(r"Unknown identifier [`'](\S+?)[`']"),
        re.compile(r"unknown module prefix [`'](\S+?)[`']"),
        re.compile(r"Unknown constant `(\S+)`"),
        re.compile(r"Unknown identifier `(\S+)`"),
    ]
    found: list[str] = []
    for pat in patterns:
        for m in pat.finditer(compiler_output):
            ident = m.group(1).rstrip("'`")
            if ident and len(ident) > 2:
                found.append(ident)
    # Deduplicate preserving order
    seen: set[str] = set()
    result: list[str] = []
    for f in found:
        if f not in seen:
            seen.add(f)
            result.append(f)
    return result


def _build_error_hint(compiler_output: str) -> str:
    """Generate a targeted hint based on the most recent compiler error.

    Maps common error patterns to specific, actionable advice that guides
    the model toward a fix rather than repeating the same mistake.
    """
    if not compiler_output:
        return ""

    hints: list[str] = []
    output_lower = compiler_output.lower()

    if "unexpected end of input" in output_lower:
        hints.append(
            "HINT: Your proof was truncated (unexpected end of input). "
            "Keep the proof SHORTER — under 50 lines. Use powerful tactics "
            "(simp, ring, omega, norm_num, linarith) that close goals in one line."
        )

    if "type mismatch" in output_lower or "application type mismatch" in output_lower:
        hints.append(
            "HINT: Type mismatch error. Use `push_cast` and `norm_cast` to "
            "align types. Cast everything to one type (ℕ, ℤ, or ℝ) early. "
            "Remember: ℕ subtraction truncates to 0 — cast to ℤ first."
        )

    if "unsolved goals" in output_lower:
        hints.append(
            "HINT: Your proof is incomplete — there are unsolved goals. "
            "Make sure every `by` block closes all goals. Try `simp_all`, "
            "`omega`, or `exact?` to close remaining goals."
        )

    if "unknown identifier" in output_lower or "unknown constant" in output_lower:
        hints.append(
            "HINT: You used a Mathlib name that does not exist. Do NOT guess "
            "names or try minor variations. Use `exact?` or `apply?` to let "
            "the compiler find the real name."
        )

    if "function expected" in output_lower:
        hints.append(
            "HINT: 'Function expected' often means a namespace is not opened. "
            "Add the appropriate `open` statement (e.g., `open Finset BigOperators`, "
            "`open Filter`, `open Set`)."
        )

    if not hints:
        return ""

    return "\n".join(hints)


def _build_direct_prompt(item: ExtractedItem) -> str:
    """Build a direct proof prompt — just the theorem, no structured plan."""
    parts = [f"Prove the following theorem in Lean 4.\n"]
    parts.append(f"**Theorem** ({item.id}): {item.statement}\n")

    if item.proof:
        parts.append(f"**Informal proof**:\n{item.proof}\n")
    elif item.proof_sketch:
        parts.append(f"**Proof sketch**:\n{item.proof_sketch}\n")

    parts.append(
        "First, state your proof approach in 1-2 sentences on a line starting with "
        "\"APPROACH:\". Then write the Lean 4 code in a ```lean code block.\n"
        "Include all necessary imports at the top."
    )
    return "\n".join(parts)


def _build_direct_retry_prompt(
    item: ExtractedItem,
    history: list["TranslationTriple"],
) -> str:
    """Direct retry — theorem + compact history of failures."""
    parts = [f"Prove the following theorem in Lean 4.\n"]
    parts.append(f"**Theorem** ({item.id}): {item.statement}\n")

    if item.proof:
        parts.append(f"**Informal proof**:\n{item.proof}\n")
    elif item.proof_sketch:
        parts.append(f"**Proof sketch**:\n{item.proof_sketch}\n")

    history_parts = []
    for idx, t in enumerate(history):
        is_most_recent = (idx == len(history) - 1)
        status = "COMPILED SUCCESSFULLY" if t.compiled else "FAILED"

        if is_most_recent:
            history_parts.append(
                f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
                f"Code:\n{t.lean_code}\n\n"
                f"Compiler output:\n{t.compiler_output}\n"
                f"--- END ATTEMPT {t.attempt_number} ---"
            )
        else:
            approach = t.reasoning if t.reasoning else _code_synopsis(t.lean_code)
            history_parts.append(
                f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
                f"Approach: {approach}\n"
                f"Compiler output:\n{t.compiler_output}\n"
                f"--- END ATTEMPT {t.attempt_number} ---"
            )

    history_text = "\n\n".join(history_parts)

    parts.append(f"PREVIOUS ATTEMPTS AND THEIR RESULTS:\n\n{history_text}\n\n")

    # Add targeted error hint based on the most recent failure
    if history and not history[-1].compiled:
        error_hint = _build_error_hint(history[-1].compiler_output)
        if error_hint:
            parts.append(f"{error_hint}\n\n")

    parts.append(
        "Learn from the failures above. Do NOT repeat the same mistakes.\n"
        "First, state your proof approach in 1-2 sentences on a line starting with "
        "\"APPROACH:\". Then write the Lean 4 code in a ```lean code block.\n"
        "Include all necessary imports at the top."
    )
    return "\n".join(parts)


# ---------------------------------------------------------------------------
# Definition prompts
# ---------------------------------------------------------------------------

def _build_definition_prompt(item: ExtractedItem) -> str:
    """Build a prompt for formalizing a definition — first attempt, no history."""
    parts = [f"Formalize the following mathematical definition in Lean 4.\n"]
    parts.append(f"**Definition** ({item.id}): {item.statement}\n")

    if item.context:
        parts.append(f"**Context**: {item.context}\n")

    if item.proof:
        parts.append(f"**Additional detail**:\n{item.proof}\n")
    elif item.proof_sketch:
        parts.append(f"**Additional detail**:\n{item.proof_sketch}\n")

    parts.append(
        "First, state which Lean 4 construct you will use and why on a line starting "
        "with \"CONSTRUCT:\". Choose from: def, noncomputable def, structure, class, "
        "instance, abbrev.\n"
        "Then write the Lean 4 code in a ```lean code block.\n"
        "Include all necessary imports at the top.\n"
        "Do NOT include any theorems about this definition — only the definition itself."
    )
    return "\n".join(parts)


def _build_definition_retry_prompt(
    item: ExtractedItem,
    history: list["TranslationTriple"],
) -> str:
    """Definition retry — definition statement + compact history of failures."""
    parts = [f"Formalize the following mathematical definition in Lean 4.\n"]
    parts.append(f"**Definition** ({item.id}): {item.statement}\n")

    if item.context:
        parts.append(f"**Context**: {item.context}\n")

    if item.proof:
        parts.append(f"**Additional detail**:\n{item.proof}\n")
    elif item.proof_sketch:
        parts.append(f"**Additional detail**:\n{item.proof_sketch}\n")

    history_parts = []
    for idx, t in enumerate(history):
        is_most_recent = (idx == len(history) - 1)
        status = "COMPILED SUCCESSFULLY" if t.compiled else "FAILED"

        if is_most_recent:
            history_parts.append(
                f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
                f"Code:\n{t.lean_code}\n\n"
                f"Compiler output:\n{t.compiler_output}\n"
                f"--- END ATTEMPT {t.attempt_number} ---"
            )
        else:
            approach = t.reasoning if t.reasoning else _code_synopsis(t.lean_code)
            history_parts.append(
                f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
                f"Approach: {approach}\n"
                f"Compiler output:\n{t.compiler_output}\n"
                f"--- END ATTEMPT {t.attempt_number} ---"
            )

    history_text = "\n\n".join(history_parts)

    parts.append(f"PREVIOUS ATTEMPTS AND THEIR RESULTS:\n\n{history_text}\n\n")

    # Add targeted error hint based on the most recent failure
    if history and not history[-1].compiled:
        error_hint = _build_error_hint(history[-1].compiler_output)
        if error_hint:
            parts.append(f"{error_hint}\n\n")

    parts.append(
        "Learn from the failures above. Do NOT repeat the same mistakes.\n"
        "First, state which Lean 4 construct you will use and why on a line starting "
        "with \"CONSTRUCT:\". Choose from: def, noncomputable def, structure, class, "
        "instance, abbrev.\n"
        "Then write the Lean 4 code in a ```lean code block.\n"
        "Include all necessary imports at the top.\n"
        "Do NOT include any theorems about this definition — only the definition itself."
    )
    return "\n".join(parts)


def _extract_construct(response: str) -> str:
    """Extract the CONSTRUCT line from a model response.

    Looks for a line starting with "CONSTRUCT:" and returns its content.
    """
    for line in response.split("\n"):
        stripped = line.strip()
        if stripped.upper().startswith("CONSTRUCT:"):
            return stripped[len("CONSTRUCT:"):].strip()
    return ""


# ---------------------------------------------------------------------------
# Guided-mode prompts (with Agent 5 structured proof)
# ---------------------------------------------------------------------------

def _build_initial_prompt(proof: StructuredProof, nl_proof: str | None = None) -> str:
    """Build the first guided translation prompt (no history)."""
    proof_json = proof.model_dump_json(indent=2)
    nl_section = f"\n**Original informal proof**:\n{nl_proof}\n" if nl_proof else ""
    return (
        f"Prove the following theorem in Lean 4.\n\n"
        f"A structured proof plan is provided below as guidance. You may follow it, "
        f"adapt it, or use a completely different approach if you know a simpler path "
        f"(e.g., a direct Mathlib lemma application).\n\n"
        f"--- PROOF PLAN (guidance) ---\n{proof_json}\n--- END ---\n"
        f"{nl_section}\n"
        f"First, state your proof approach in 1-2 sentences on a line starting with "
        f"\"APPROACH:\". Then write the Lean 4 code in a ```lean code block.\n"
        f"Include all necessary imports at the top."
    )


def _build_retry_prompt(
    proof: StructuredProof,
    history: list[TranslationTriple],
    nl_proof: str | None = None,
) -> str:
    """Build a guided retry prompt with full history of previous attempts.

    Older attempts are shown as compact summaries (reasoning + error).
    The most recent attempt gets full code + error so the model can
    see exactly what to fix.
    """
    proof_json = proof.model_dump_json(indent=2)
    nl_section = f"\n**Original informal proof**:\n{nl_proof}\n" if nl_proof else ""

    history_parts = []
    for idx, t in enumerate(history):
        is_most_recent = (idx == len(history) - 1)
        status = "COMPILED SUCCESSFULLY" if t.compiled else "FAILED"

        if is_most_recent:
            # Most recent: full code + error
            history_parts.append(
                f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
                f"Code:\n{t.lean_code}\n\n"
                f"Compiler output:\n{t.compiler_output}\n"
                f"--- END ATTEMPT {t.attempt_number} ---"
            )
        else:
            # Older: compact summary
            approach = t.reasoning if t.reasoning else _code_synopsis(t.lean_code)
            history_parts.append(
                f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
                f"Approach: {approach}\n"
                f"Compiler output:\n{t.compiler_output}\n"
                f"--- END ATTEMPT {t.attempt_number} ---"
            )

    history_text = "\n\n".join(history_parts)

    # Add targeted error hint based on the most recent failure
    error_hint_section = ""
    if history and not history[-1].compiled:
        error_hint = _build_error_hint(history[-1].compiler_output)
        if error_hint:
            error_hint_section = f"{error_hint}\n\n"

    return (
        f"Prove the following theorem in Lean 4.\n\n"
        f"A structured proof plan is provided below as guidance. You may follow it, "
        f"adapt it, or use a completely different approach if you know a simpler path.\n\n"
        f"--- PROOF PLAN (guidance) ---\n{proof_json}\n--- END ---\n"
        f"{nl_section}\n"
        f"PREVIOUS ATTEMPTS AND THEIR RESULTS:\n\n{history_text}\n\n"
        f"{error_hint_section}"
        f"Learn from the failures above. Do NOT repeat the same mistakes.\n"
        f"First, state your proof approach in 1-2 sentences on a line starting with "
        f"\"APPROACH:\". Then write the Lean 4 code in a ```lean code block.\n"
        f"Include all necessary imports at the top."
    )


# ---------------------------------------------------------------------------
# Goedel-Prover compact prompt format
# ---------------------------------------------------------------------------

def _proof_to_nl(proof: StructuredProof) -> str:
    """Convert a StructuredProof to compact NL text for Goedel's prompt format."""
    parts = [f"**Statement**: {proof.goal_statement}"]
    parts.append(f"**Strategy**: {proof.strategy}")

    if proof.assumptions:
        parts.append("**Assumptions**:")
        for a in proof.assumptions:
            hint = f" : {a.lean_type_hint}" if a.lean_type_hint else ""
            parts.append(f"- {a.name}{hint}: {a.statement}")

    parts.append("**Proof**:")
    for step in proof.steps:
        hint = f" (by {step.lean_tactic_hint})" if step.lean_tactic_hint else ""
        parts.append(f"{step.step_number}. {step.description}{hint}")

    if proof.dependencies:
        parts.append("**Dependencies**:")
        for d in proof.dependencies:
            parts.append(f"- {d.name}: {d.statement}")

    return "\n".join(parts)


def _build_goedel_prompt(proof: StructuredProof, lessons: str = "") -> str:
    """Build a compact prompt matching Goedel-Prover's training format."""
    nl = _proof_to_nl(proof)
    rules = ""
    if lessons:
        # Extract just the bullet points from the tuner (skip headers)
        condensed = "\n".join(
            l for l in lessons.split("\n")
            if l.strip().startswith("- ") or l.strip().startswith("* ")
        )
        if condensed:
            rules = f"\n### Rules\n{condensed}\n"
    # Seed the continuation with common imports/opens so the model
    # doesn't have to guess namespace boilerplate.
    preamble = "import Mathlib\nopen Finset BigOperators\n"

    return (
        f"### Instruction\n"
        f"Translate the following mathematical proof into Lean 4 code.\n"
        f"Output ONLY valid Lean 4 code. No markdown, no explanation.\n"
        f"Output ONE theorem/lemma only — stop after the proof.\n"
        f"{rules}\n"
        f"### Natural Language Proof\n{nl}\n\n"
        f"### Lean 4 Code\n{preamble}"
    )


def _build_goedel_retry_prompt(
    proof: StructuredProof,
    history: list[TranslationTriple],
    lessons: str = "",
) -> str:
    """Build a Goedel retry prompt with failed attempts and errors."""
    nl = _proof_to_nl(proof)

    # Include only the most recent failed attempt (save context for 8K models)
    recent_failures = [t for t in history if not t.compiled][-1:]
    attempts_text = ""
    for t in recent_failures:
        code_snippet = t.lean_code[:400] if len(t.lean_code) > 400 else t.lean_code
        attempts_text += (
            f"\n--- ATTEMPT {t.attempt_number} (FAILED) ---\n"
            f"{code_snippet}\n"
            f"Error: {t.compiler_output[:200]}\n"
        )

    rules = ""
    if lessons:
        condensed = "\n".join(
            l for l in lessons.split("\n")
            if l.strip().startswith("- ") or l.strip().startswith("* ")
        )
        if condensed:
            rules = f"\n### Rules\n{condensed}\n"

    preamble = "import Mathlib\nopen Finset BigOperators\n"

    return (
        f"### Instruction\n"
        f"Translate the following mathematical proof into Lean 4 code.\n"
        f"Previous attempts failed. Study the errors and produce CORRECT Lean 4 code.\n"
        f"Output ONLY valid Lean 4 code. No markdown, no explanation.\n"
        f"Output ONE theorem/lemma only — stop after the proof.\n"
        f"{rules}\n"
        f"### Natural Language Proof\n{nl}\n"
        f"{attempts_text}\n"
        f"### Lean 4 Code\n{preamble}"
    )


def _code_synopsis(lean_code: str, max_lines: int = 5) -> str:
    """Extract a brief synopsis from Lean code (first few meaningful lines).

    Used as a fallback when no reasoning summary is available (e.g., adapter).
    """
    if not lean_code:
        return "(empty)"
    lines = [l for l in lean_code.split("\n") if l.strip()]
    # Skip import/open lines to get to the theorem signature
    meaningful = [l for l in lines if not l.strip().startswith(("import ", "open "))]
    if not meaningful:
        meaningful = lines
    return "\n".join(meaningful[:max_lines])


def _extract_reasoning(response: str) -> str:
    """Extract the APPROACH line from a model response.

    Looks for a line starting with "APPROACH:" and returns its content.
    """
    for line in response.split("\n"):
        stripped = line.strip()
        if stripped.upper().startswith("APPROACH:"):
            return stripped[len("APPROACH:"):].strip()
    return ""


def _is_goedel_model(model: str) -> bool:
    """Check if a model string refers to a Goedel-Prover variant (or its adapter)."""
    lower = model.lower()
    return "goedel" in lower or "translator_v" in lower


def _extract_lean_code(response: str) -> str:
    """Extract Lean code from response, stripping markdown fences and headers."""
    import re
    text = response.strip()

    # Strip DeepSeek-style <think>...</think> reasoning blocks before any
    # other processing.  The model wraps its chain-of-thought in these tags;
    # the actual answer follows after the closing tag.
    text = re.sub(r"<think>.*?</think>", "", text, flags=re.DOTALL).strip()
    # Also strip unclosed <think> blocks (model ran out of tokens mid-reasoning)
    text = re.sub(r"<think>.*", "", text, flags=re.DOTALL).strip()

    # Try to extract code from markdown fences (```lean, ```lean4, or plain ```)
    fence_match = re.search(r"```(?:lean4?|lean)?\s*\n(.*?)```", text, re.DOTALL)
    if fence_match:
        text = fence_match.group(1)

    # Strip Goedel-style markdown headers (### Lean 4 Proof, ### Lean 4 Code, etc.)
    lines = text.split("\n")
    lines = [l for l in lines if not l.strip().startswith("### ")]
    # Also strip any remaining ``` lines
    lines = [l for l in lines if not l.strip().startswith("```")]

    # Find the first line that looks like Lean code (import, theorem, def, etc.)
    start = 0
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped and (
            stripped.startswith("import ")
            or stripped.startswith("open ")
            or stripped.startswith("theorem ")
            or stripped.startswith("lemma ")
            or stripped.startswith("def ")
            or stripped.startswith("axiom ")
            or stripped.startswith("noncomputable")
            or stripped.startswith("structure ")
            or stripped.startswith("class ")
            or stripped.startswith("instance ")
            or stripped.startswith("abbrev ")
            or stripped.startswith("section")
            or stripped.startswith("namespace")
            or stripped.startswith("--")
        ):
            start = i
            break

    code_lines = lines[start:]

    # Truncate after the first declaration — stop at the first `example`
    # or second top-level `theorem`/`lemma`/`def` (the adapter sometimes
    # generates many variations after the main proof).
    decl_count = 0
    end = len(code_lines)
    for i, line in enumerate(code_lines):
        stripped = line.strip()
        if stripped.startswith("example "):
            end = i
            break
        if stripped.startswith(("theorem ", "lemma ", "def ")) and i > 0:
            decl_count += 1
            if decl_count >= 2:
                end = i
                break

    result = "\n".join(code_lines[:end]).strip()

    # Fallback: if extraction produced nothing but the original response
    # contains a declaration keyword, try aggressive line-based extraction.
    if not result and response:
        raw_lines = response.split("\n")
        for idx, raw_line in enumerate(raw_lines):
            s = raw_line.strip()
            if s.startswith((
                "theorem ", "lemma ", "def ", "structure ",
                "class ", "instance ", "abbrev ", "noncomputable ",
            )):
                result = "\n".join(raw_lines[idx:]).strip()
                break

    # Ensure standard preamble is present (adapter models continue from
    # the prompt prefix so they omit it from their output).
    if result and not result.startswith("import "):
        preamble = "import Mathlib\nopen Finset BigOperators\n\n"
        result = preamble + result

    return result


# ---------------------------------------------------------------------------
# Tier 3: Hard theorem decomposition
# ---------------------------------------------------------------------------

@dataclass
class SubLemma:
    """A sub-lemma produced by the decomposer."""
    name: str
    lean_signature: str
    nl_description: str
    nl_proof_hint: str
    depends_on: list[str] = field(default_factory=list)


@dataclass
class Decomposition:
    """Result of decomposing a hard theorem into sub-lemmas."""
    analysis: str
    sub_lemmas: list[SubLemma]
    assembly: str  # Lean code combining sub-lemmas into the main theorem


@dataclass
class DecomposedResult:
    """Result of the Tier 3 decomposition + proving pipeline."""
    decomposition: Decomposition
    sub_results: dict[str, TranslationResult]  # name → result per sub-lemma
    assembly_result: TranslationResult | None  # result of assembling the final theorem
    all_triples: list[TranslationTriple]  # all triples from all sub-lemmas


def _build_decomposition_prompt(
    item: ExtractedItem,
    history: list[TranslationTriple],
) -> str:
    """Build the decomposition prompt with failed attempt summaries."""
    parts = [
        f"## Theorem to decompose\n",
        f"**Name**: {item.id}",
        f"**Statement**: {item.statement}\n",
    ]

    if item.proof:
        parts.append(f"**Informal proof**:\n{item.proof}\n")
    elif item.proof_sketch:
        parts.append(f"**Proof sketch**:\n{item.proof_sketch}\n")

    # Summarize failed attempts — compact to fit context
    if history:
        parts.append(f"## Previous attempts ({len(history)} total, all failed)\n")
        # Show up to 6 diverse failures (first 2, last 2, 2 from middle)
        indices = set()
        n = len(history)
        for i in [0, 1, n // 3, 2 * n // 3, n - 2, n - 1]:
            if 0 <= i < n:
                indices.add(i)
        for i in sorted(indices):
            t = history[i]
            approach = t.reasoning if t.reasoning else _code_synopsis(t.lean_code, max_lines=3)
            err_short = t.compiler_output[:200].replace("\n", " ")
            parts.append(
                f"**Attempt {t.attempt_number}** ({t.model}):\n"
                f"  Approach: {approach}\n"
                f"  Error: {err_short}\n"
            )

    parts.append(
        "\nDecompose this theorem into independently provable sub-lemmas. "
        "Respond with ONLY valid JSON following your system prompt format."
    )
    return "\n".join(parts)


def _parse_decomposition(data: dict) -> Decomposition:
    """Parse the decomposer's JSON output into a Decomposition."""
    sub_lemmas = [
        SubLemma(
            name=sl["name"],
            lean_signature=sl["lean_signature"],
            nl_description=sl["nl_description"],
            nl_proof_hint=sl.get("nl_proof_hint", ""),
            depends_on=sl.get("depends_on", []),
        )
        for sl in data.get("sub_lemmas", [])
    ]
    return Decomposition(
        analysis=data.get("analysis", ""),
        sub_lemmas=sub_lemmas,
        assembly=data.get("assembly", ""),
    )


def _build_sub_lemma_prompt(sub: SubLemma) -> str:
    """Build a direct-style prompt for proving a single sub-lemma."""
    parts = [
        f"Prove the following lemma in Lean 4.\n",
        f"**Lean signature**:\n```lean\n{sub.lean_signature}\n```\n",
        f"**What it states**: {sub.nl_description}\n",
    ]
    if sub.nl_proof_hint:
        parts.append(f"**Proof hint**: {sub.nl_proof_hint}\n")
    parts.append(
        "Write the complete Lean 4 code (with `import Mathlib`) in a ```lean code block.\n"
        "The signature above may need minor adjustments — fix any type errors "
        "while preserving the mathematical content."
    )
    return "\n".join(parts)


def _build_assembly_prompt(
    decomp: Decomposition,
    proved_lemmas: dict[str, str],  # name → compiled lean code
    item: ExtractedItem,
) -> str:
    """Build a prompt to assemble proved sub-lemmas into the main theorem."""
    parts = [
        f"Assemble the following proved sub-lemmas into a proof of the main theorem.\n",
        f"**Main theorem** ({item.id}): {item.statement}\n",
        f"**Proposed assembly skeleton**:\n```lean\n{decomp.assembly}\n```\n",
        f"**Proved sub-lemmas** (these compile successfully):\n",
    ]
    for name, code in proved_lemmas.items():
        parts.append(f"```lean\n-- {name}\n{code}\n```\n")

    parts.append(
        "Write a single Lean 4 file that includes all the sub-lemmas above "
        "and uses them to prove the main theorem. You may adjust the assembly "
        "code, add intermediate steps, or modify sub-lemma interfaces as needed.\n"
        "Output the complete file in a ```lean code block."
    )
    return "\n".join(parts)


def _signature_to_axiom_body(signature: str) -> str:
    """Strip lemma/theorem keyword from a Lean signature.

    Input:  'lemma step1_coprime (hp : Nat.Prime p) : True'
    Output: 'step1_coprime (hp : Nat.Prime p) : True'
    """
    sig = signature.strip()
    for prefix in ("lemma ", "theorem ", "def ", "axiom "):
        if sig.startswith(prefix):
            return sig[len(prefix):]
    return sig


def _build_axiom_assembly_prompt(
    decomp: 'Decomposition',
    item: ExtractedItem,
) -> str:
    """Build a prompt to assemble the main theorem using axiomatized sub-lemmas.

    Each sub-lemma is declared as a Lean axiom. The model must prove the
    main theorem using only these axioms (plus Mathlib). This validates
    the decomposition structure without requiring sub-lemma proofs.
    """
    axiom_block = "\n".join(
        f"axiom {_signature_to_axiom_body(sl.lean_signature)}"
        for sl in decomp.sub_lemmas
    )

    parts = [
        f"Prove the main theorem using the axiomatized sub-lemmas below.\n",
        f"**Main theorem** ({item.id}): {item.statement}\n",
        f"**Axiomatized sub-lemmas** (use these as given facts):\n",
        f"```lean\nimport Mathlib\n\n{axiom_block}\n```\n",
    ]
    if decomp.assembly:
        parts.append(
            f"**Proposed assembly skeleton**:\n```lean\n{decomp.assembly}\n```\n"
        )
    parts.append(
        "Write a single Lean 4 file that starts with `import Mathlib`, "
        "redeclares the axioms above, then proves the main theorem using them. "
        "You may adjust the assembly code and add intermediate steps.\n"
        "Output the complete file in a ```lean code block."
    )
    return "\n".join(parts)


# ---------------------------------------------------------------------------
# Oracle tier: last resort for hard theorems
# ---------------------------------------------------------------------------

_ORACLE_SYSTEM = """\
You are a Lean 4 expert performing a LAST RESORT analysis. The theorem below has \
FAILED 16+ prior attempts across multiple models (DeepSeek Reasoner, Gemini 2.5 Pro) \
and a decomposition strategy. All standard approaches have been exhausted.

Your job is different from a normal translation attempt:
1. **ANALYZE** the failure patterns first — what went wrong across all prior attempts?
2. **IDENTIFY** the root cause — is it a type coercion issue, a wrong Mathlib API, \
a fundamentally flawed proof strategy, or something else?
3. **PRODUCE** a proof using a DIFFERENT approach — not a variation of what was tried.

## Critical Rules
- Start with `import Mathlib`
- Prefer short proofs. If a Mathlib lemma solves it directly, use it.
- Use `by` tactic blocks. Use `simp`, `norm_num`, `omega`, `linarith` for arithmetic.
- Do NOT guess Mathlib lemma names — if unsure, use `exact?` or `apply?`.
- Use Lean 4 syntax (not Lean 3).
- For ℕ division, cast to ℤ/ℚ or reformulate to avoid floor division.
- You MUST produce a `theorem`, `lemma`, or `def` declaration.

## Type coercion (CRITICAL)
- Pick ONE type (ℕ, ℤ, ℝ) and stay in it. Cast everything at the start.
- Use `↑` or `(· : TargetType)` for explicit casts.
- `push_cast` pushes casts inward. `norm_cast` normalizes cast expressions.
- WRONG: `(↑(n / 2) : ℝ)` — casts the floor result. RIGHT: `(↑n : ℝ) / 2`.

## Mathlib naming conventions
Names follow `Namespace.property_args`. Examples: `Nat.add_comm`, `List.map_cons`.
- `_of_` means "given that", `_iff_` for biconditionals
- NO `Nat.triangular`, `Nat.fibonacci`, `Nat.isPrime`, `Nat.isEven`, `Nat.sum_range`
- Use `Nat.Prime` (Prop), `Even n`, `Odd n`, `Irrational (Real.sqrt 2)`
- Sums: `Finset.sum (Finset.range n) f`, key lemma: `Finset.sum_range_succ`
- On "Unknown constant": do NOT try minor name variations. Use `exact?`/`apply?`.

## Key strategy guidance
- If all prior attempts used the same proof structure, try a FUNDAMENTALLY different one.
- If prior attempts all hit type mismatches, reformulate the entire statement type.
- If prior attempts hallucinated Mathlib names, use only `simp`, `ring`, `omega`, \
`norm_num`, `linarith`, `field_simp`, `positivity` — tactics that don't need named lemmas.
- Consider: can the theorem be restated equivalently in a way that's easier to prove?
- Sometimes the simplest proofs work: `by decide`, `by norm_num`, `by omega`.
"""


def _build_oracle_prompt(
    item: ExtractedItem,
    all_triples: list[TranslationTriple],
) -> str:
    """Build the oracle prompt with full failure history and root-cause analysis request.

    Shows ALL prior triples: compact summaries for older ones, full code for
    the last 3 attempts. Asks for explicit failure analysis before the proof.
    """
    parts = [
        "# ORACLE MODE: Last Resort Analysis\n",
        f"**Theorem** ({item.id}): {item.statement}\n",
    ]

    if item.proof:
        parts.append(f"**Informal proof**:\n{item.proof}\n")
    elif item.proof_sketch:
        parts.append(f"**Proof sketch**:\n{item.proof_sketch}\n")

    # Failure history
    parts.append(f"## ALL {len(all_triples)} PRIOR ATTEMPTS (all failed)\n")

    # Determine which attempts get full code (last 3)
    full_code_start = max(0, len(all_triples) - 3)

    for idx, t in enumerate(all_triples):
        status = "COMPILED SUCCESSFULLY" if t.compiled else "FAILED"
        if idx >= full_code_start:
            # Full code for recent attempts
            parts.append(
                f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
                f"Approach: {t.reasoning or '(not stated)'}\n"
                f"Code:\n{t.lean_code}\n\n"
                f"Compiler output:\n{t.compiler_output}\n"
                f"--- END ATTEMPT {t.attempt_number} ---\n"
            )
        else:
            # Compact summary for older attempts
            approach = t.reasoning if t.reasoning else _code_synopsis(t.lean_code, max_lines=3)
            err_short = t.compiler_output[:200].replace("\n", " ")
            parts.append(
                f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
                f"Approach: {approach}\n"
                f"Error: {err_short}\n"
                f"--- END ATTEMPT {t.attempt_number} ---\n"
            )

    # Failure analysis request
    parts.append(
        "## FAILURE ANALYSIS REQUEST\n"
        "Before writing code, you MUST analyze the failures above:\n"
        "1. What is the COMMON ERROR PATTERN across attempts?\n"
        "2. What approach has NOT been tried yet?\n"
        "3. What is the ROOT CAUSE of repeated failures "
        "(wrong API, wrong type, wrong strategy)?\n\n"
        "Write your analysis in an `ANALYSIS:` section (multiple lines OK).\n"
        "Then state your new approach in an `APPROACH:` line.\n"
        "Then write the Lean 4 code in a ```lean code block.\n"
        "Include all necessary imports at the top."
    )
    return "\n".join(parts)


def _extract_oracle_analysis(response: str) -> str:
    """Extract the ANALYSIS section from an oracle model response.

    Looks for content between 'ANALYSIS:' and 'APPROACH:' (or code fence).
    Returns the analysis text, or empty string if not found.
    """
    lines = response.split("\n")
    in_analysis = False
    analysis_lines: list[str] = []

    for line in lines:
        stripped = line.strip()
        if stripped.upper().startswith("ANALYSIS:"):
            in_analysis = True
            # Include content after "ANALYSIS:" on the same line
            rest = stripped[len("ANALYSIS:"):].strip()
            if rest:
                analysis_lines.append(rest)
            continue
        if in_analysis:
            if stripped.upper().startswith("APPROACH:") or stripped.startswith("```"):
                break
            analysis_lines.append(line)

    return "\n".join(analysis_lines).strip()


# ---------------------------------------------------------------------------
# History distillation
# ---------------------------------------------------------------------------

_DISTILL_SYSTEM = """\
You are reviewing failed Lean 4 proof attempts. Your job is to produce a concise
summary that helps the next attempt avoid repeating mistakes.

For each failed attempt, extract:
1. The proof STRATEGY (1 sentence: what approach was tried)
2. The ROOT CAUSE of failure (1 sentence: the specific Lean error and why it happened)
3. Any IDENTIFIERS that were wrong (hallucinated Mathlib names, wrong namespaces)

Then write a RECOMMENDATIONS section with concrete advice for the next attempt.

Keep the entire summary under 20 lines. Be specific — name exact identifiers,
tactics, and type mismatches. Do NOT include any Lean code.
"""


def _distill_history(
    triples: list['TranslationTriple'],
    model: str,
    item_statement: str = "",
    cli_timeout: int = 300,
) -> str:
    """Distill a list of failed triples into a compact summary.

    Called at tier boundaries to compress the growing history into a
    fixed-size summary. The next tier sees this summary instead of the
    raw code/error pairs from prior tiers.

    Returns a text summary (~10-20 lines) or empty string on failure.
    """
    if not triples:
        return ""

    # Only include failed attempts (successes shouldn't be here, but guard)
    failed = [t for t in triples if not t.compiled]
    if not failed:
        return ""

    parts = []
    if item_statement:
        parts.append(f"Theorem: {item_statement[:300]}\n")

    parts.append(f"{len(failed)} attempts failed:\n")
    for t in failed:
        code_snippet = t.lean_code[:300] if t.lean_code else "(empty)"
        error_snippet = t.compiler_output[:200] if t.compiler_output else "(no error)"
        approach = t.reasoning if t.reasoning else "(no stated approach)"
        parts.append(
            f"--- Attempt {t.attempt_number} ({t.model}) ---\n"
            f"Approach: {approach}\n"
            f"Code (first 300 chars): {code_snippet}\n"
            f"Error: {error_snippet}\n"
        )

    parts.append(
        "\nSummarize these failures. For each attempt: strategy (1 line), "
        "root cause (1 line), wrong identifiers (if any). "
        "Then write RECOMMENDATIONS for the next attempt. "
        "Keep under 20 lines total."
    )

    prompt = "\n".join(parts)

    try:
        summary = complete(
            model, prompt,
            system=_DISTILL_SYSTEM,
            max_tokens=2048,
            temperature=0.0,
            cli_timeout=cli_timeout,
        )
        return summary.strip()
    except Exception as e:
        _logger.warning("History distillation failed: %s", e)
        # Fall back to a mechanical summary (no LLM)
        lines = [f"Prior attempts summary ({len(failed)} failures):"]
        for t in failed:
            err_short = (t.compiler_output or "")[:80].replace("\n", " ")
            approach = t.reasoning[:60] if t.reasoning else "no stated approach"
            lines.append(f"  - Attempt {t.attempt_number}: {approach} → {err_short}")
        return "\n".join(lines)


# ---------------------------------------------------------------------------
# Main agent
# ---------------------------------------------------------------------------

class TranslatorAgent:
    """Agent 6: Translate theorems to Lean 4.

    Two-phase translation with three tiers of escalation:
      Phase 1 (Direct): 3× DeepSeek, no Agent 5 plan.
      Phase 2 (Guided):
        Tier 1: 7× DeepSeek  (attempts 4-10)
        Tier 2: 5× Gemini    (attempts 11-15)
        Tier 3: Decompose into sub-lemmas, prove each independently (attempt 16)

    Budget: 3 + 7 + 5 + 1 = 16 max attempts per theorem.

    Tier 3 is the "hard theorem path" — triggered only when all monolithic
    attempts fail. A decomposer model breaks the theorem into sub-lemmas,
    each proved independently. Partial success generates training data.
    """

    def __init__(
        self,
        compiler: LeanCompiler,
        tier1_model: str = TIER1_MODEL,
        tier2_model: str = TIER2_MODEL,
        tuner: PromptTuner | None = None,
        mathlib_index: MathlibIndex | None = None,
        loogle_client: LoogleClient | None = None,
        strategy_kb: StrategyKB | None = None,
    ):
        self.compiler = compiler
        self.tier1_model = tier1_model
        self.tier2_model = tier2_model
        self.tuner = tuner or PromptTuner()
        self.mathlib_index = mathlib_index
        self.strategy_kb = strategy_kb
        self.pre_compiler = PreCompiler(mathlib_index=mathlib_index)
        # Loogle: create a default client if enabled and none provided
        if loogle_client is not None:
            self.loogle = loogle_client
        elif LOOGLE_ENABLED:
            self.loogle = LoogleClient()
        else:
            self.loogle = None

    def _get_dependency_context(self, item: ExtractedItem | None) -> str:
        """Retrieve proved Lean implementations for this item's dependencies.

        Searches the rosetta entries in the MathlibIndex for each dependency ID.
        Returns a formatted prompt section listing available Lean code, or empty
        string if no dependencies are found/proved.
        """
        if item is None or not item.dependencies or not self.mathlib_index:
            return ""

        found: list[tuple[str, str, str]] = []  # (dep_id, signature, docstring)
        for dep_id in item.dependencies:
            if dep_id.startswith("External:"):
                continue  # external refs aren't in the rosetta
            decl = self.mathlib_index.get_by_name(dep_id)
            if decl is None or decl.source != "rosetta":
                continue
            # signature stores a Lean code snippet; docstring stores the NL statement
            sig = decl.signature.strip()
            if not sig:
                continue
            found.append((dep_id, sig, decl.docstring.strip()))

        if not found:
            return ""

        lines = [
            "## Proven Dependencies",
            "The following dependencies are already formalized in this corpus. "
            "Reference or reuse their definitions/theorems instead of axiomatizing them.",
            "",
        ]
        for dep_id, sig, doc in found:
            lines.append(f"### {dep_id}")
            if doc:
                lines.append(f"NL: {doc}")
            lines.append(f"```lean\n{sig}\n```")
            lines.append("")

        return "\n".join(lines)

    @staticmethod
    def _get_warm_start_context(
        reference_lean: str | None,
        reference_name: str | None = None,
        reference_similarity: float = 0.0,
    ) -> str:
        """Build a warm-start prompt section from a similar proved theorem.

        When the Librarian finds a partial match (0.5-0.9 similarity) against
        the Rosetta Stone, we inject the matched theorem's Lean code as a
        reference proof. The model can adapt it rather than starting from
        scratch, dramatically reducing attempts.
        """
        if not reference_lean:
            return ""

        sim_pct = f"{reference_similarity:.0%}" if reference_similarity else "?"
        lines = [
            "## Reference Proof (Warm Start)",
            f"A similar theorem (`{reference_name}`, {sim_pct} similarity) has "
            "already been proved. Use it as a starting point — adapt the proof "
            "structure, imports, and identifiers to match the NEW statement below. "
            "Do NOT copy it verbatim if the statements differ.",
            "",
            f"```lean",
            reference_lean.strip(),
            "```",
            "",
        ]
        return "\n".join(lines)

    def _get_mathlib_hints(
        self,
        query: str,
        top_k: int = 15,
        nl_proof: str | None = None,
        compiler_errors: list[str] | None = None,
    ) -> str:
        """Retrieve relevant Mathlib declarations for prompt injection.

        Uses multi-query search to maximize recall:
        1. Search by goal statement (mathematical content)
        2. Search by NL proof text (often mentions lemma names)
        3. Search by unknown identifiers from ALL compiler errors (error-driven)
        4. Search by partial identifier segments (fuzzy fallback)
        5. Loogle type-based search (if enabled) — merged with TF-IDF results

        Returns a formatted hint section, or empty string if no index
        is available or no results found.
        """
        has_tfidf = self.mathlib_index is not None and self.mathlib_index.size > 0
        has_loogle = self.loogle is not None

        if not has_tfidf and not has_loogle:
            return ""

        # Collect results from multiple queries, dedup by name
        seen: dict[str, SearchResult] = {}

        def _merge(results: list[SearchResult]) -> None:
            for r in results:
                if r.name not in seen or r.score > seen[r.name].score:
                    seen[r.name] = r

        def _merge_loogle(loogle_results: list[LoogleResult], boost: float = 0.1) -> None:
            """Convert Loogle results to SearchResult and merge with a score boost.

            Loogle results are type-precise, so they get a slight priority boost
            over TF-IDF results.  The boost is added to a base score of 0.8
            (Loogle results don't carry a numeric relevance score).
            """
            for lr in loogle_results:
                base_score = 0.8 + boost
                sr = SearchResult(
                    name=lr.name,
                    signature=lr.type_sig,
                    docstring=lr.doc,
                    score=base_score,
                    source="mathlib",
                )
                if sr.name not in seen or sr.score > seen[sr.name].score:
                    seen[sr.name] = sr

        # --- TF-IDF queries (when index is available) ---
        if has_tfidf:
            # Query 1: goal statement
            _merge(self.mathlib_index.search(query, top_k=top_k))

            # Query 2: NL proof (often contains real lemma/theorem names)
            if nl_proof:
                _merge(self.mathlib_index.search(nl_proof, top_k=top_k))

        # --- Loogle queries (when enabled) ---
        if has_loogle:
            try:
                # Query L1: goal statement — may find exact type match
                _merge_loogle(self.loogle.search(query, num_results=top_k))

                # Query L2: unknown identifiers from errors — find correct names
                if compiler_errors:
                    all_unknown_l: list[str] = []
                    for err in compiler_errors:
                        all_unknown_l.extend(_extract_unknown_identifiers(err))
                    unique_l = list(dict.fromkeys(all_unknown_l))  # dedup, keep order
                    for ident in unique_l[:5]:  # top 5 to stay within rate limits
                        _merge_loogle(self.loogle.search(ident, num_results=3))
            except Exception as exc:
                _logger.warning("Loogle search failed, falling back to TF-IDF only: %s", exc)

        # --- Error-driven TF-IDF queries ---
        if has_tfidf and compiler_errors:
            all_unknown: list[str] = []
            for err in compiler_errors:
                all_unknown.extend(_extract_unknown_identifiers(err))
            # Deduplicate preserving order, prioritize frequent ones
            from collections import Counter
            freq = Counter(all_unknown)
            unique_unknown = sorted(set(all_unknown), key=lambda x: -freq[x])

            for ident in unique_unknown[:10]:  # top 10 most-repeated unknowns
                _merge(self.mathlib_index.search(ident, top_k=5))
                # Also try partial segments for fuzzy matching:
                # 'Nat.Prime.eq_one' → search 'Prime.eq_one', 'eq_one'
                parts = ident.split(".")
                if len(parts) >= 2:
                    _merge(self.mathlib_index.search(
                        ".".join(parts[-2:]), top_k=3))

        if not seen:
            return ""

        # Sort by score, take top_k
        ranked = sorted(seen.values(), key=lambda r: -r.score)[:top_k]

        # Format as hint section
        lines = [
            "## Relevant Mathlib lemmas",
            "The following Mathlib declarations may be useful. Use these EXACT "
            "names — do NOT guess or modify them.\n",
        ]
        for r in ranked:
            if r.signature:
                lines.append(f"- `{r.name}` : {r.signature}")
            else:
                lines.append(f"- `{r.name}`")
            if r.docstring:
                doc_short = r.docstring.split("\n")[0][:120]
                lines.append(f"  {doc_short}")

        return "\n".join(lines)

    def _get_strategy_hints(self, item: ExtractedItem | None) -> str:
        """Retrieve strategy hints from the Knowledge Base for prompt injection.

        Returns a formatted hint section, or empty string if no KB is
        available or no relevant strategies found.
        """
        if self.strategy_kb is None or self.strategy_kb.size == 0 or item is None:
            return ""

        from ..knowledge_graph import _extract_math_objects
        domain = ""
        cat_file = detect_math_category(item)
        if cat_file:
            domain = cat_file.replace(".md", "")

        objects = _extract_math_objects(item.statement or "")

        return self.strategy_kb.format_strategy_hints(
            domain=domain,
            mathematical_objects=objects,
            statement=item.statement or "",
            top_k=3,
        )

    def _try_identifier_repair(
        self,
        lean_code: str,
        compiler_output: str,
    ) -> tuple[str, bool, str] | None:
        """Try to fix unknown identifiers by finding close Mathlib matches.

        Extracts unknown identifiers from compiler output, searches the
        Mathlib index for close matches (similarity > 0.85), auto-replaces,
        and recompiles. This catches the common case where the model
        hallucinated a slightly wrong name (e.g. 'Nat.prime_dvd' vs
        'Nat.Prime.dvd').

        Returns:
            (fixed_code, compiled, compiler_output) if repair succeeded,
            None if no repair was possible or repair didn't fix compilation.
        """
        if self.mathlib_index is None or self.mathlib_index.size == 0:
            return None

        unknowns = _extract_unknown_identifiers(compiler_output)
        if not unknowns:
            return None

        # Find replacements for each unknown identifier
        replacements: dict[str, str] = {}
        for ident in unknowns:
            results = self.mathlib_index.search(ident, top_k=5)
            if not results:
                continue
            # Check similarity of the top match
            best = results[0]
            similarity = difflib.SequenceMatcher(
                None, ident.lower(), best.name.lower()
            ).ratio()
            if similarity > 0.85:
                replacements[ident] = best.name

        if not replacements:
            return None

        # Apply replacements
        fixed = lean_code
        for old_name, new_name in replacements.items():
            fixed = fixed.replace(old_name, new_name)

        if fixed == lean_code:
            return None  # no actual changes made

        repair_summary = ", ".join(
            f"{old} -> {new}" for old, new in replacements.items()
        )
        print(f"    Identifier repair: {repair_summary}")

        # Recompile with fixes
        compiled, new_output = self.compiler.compile(fixed)
        if compiled:
            return (fixed, True, new_output)

        # Repair didn't fix compilation — don't return partial fix
        return None

    def translate_direct(
        self,
        item: ExtractedItem,
        max_attempts: int | None = None,
        model: str | None = None,
        reference_lean: str | None = None,
        reference_name: str | None = None,
        reference_similarity: float = 0.0,
    ) -> TranslationResult:
        """Try to prove directly without a structured proof plan.

        Uses the model's own mathematical knowledge — analogous to asking
        a model in a browser to prove a theorem. If successful, Agent 5
        is never called. If unsuccessful, the triples can be passed to
        translate() for guided mode.

        Operational failures (empty code, truncation, env issues) do not
        count against the attempt budget, up to MAX_OPERATIONAL_RETRIES.

        Set LK_TRANSLATOR_DIRECT_ATTEMPTS=0 to skip this phase entirely.
        """
        max_attempts = max_attempts if max_attempts is not None else MAX_DIRECT_ATTEMPTS
        model = model or DIRECT_MODEL

        if max_attempts <= 0:
            return TranslationResult(
                outcome=TranslationOutcome.NEEDS_HUMAN,
                triples=[],
                total_attempts=0,
            )

        minimal = _minimal_proof(item)
        triples: list[TranslationTriple] = []

        # Detect category once for all attempts in this phase
        _item_cat_file = detect_math_category(item)
        if _item_cat_file:
            cat_label = _item_cat_file.replace(".md", "")
            print(f"  [Agent 6] Direct phase: {model} "
                  f"(up to {max_attempts} attempts, "
                  f"category={cat_label})")
        else:
            print(f"  [Agent 6] Direct phase: {model} "
                  f"(up to {max_attempts} attempts)")

        genuine_attempts = 0
        operational_retries = 0
        current_max_tokens = DIRECT_MAX_TOKENS

        while genuine_attempts < max_attempts:
            attempt_num = len(triples) + 1
            temperature = 0.0 if genuine_attempts == 0 else RETRY_TEMPERATURE

            # Lightweight system prompt + tuner lessons + Mathlib hints
            current_errors = [
                t.compiler_output for t in triples
                if not t.compiled and t.compiler_output
            ]
            lessons = self.tuner.get_lessons(
                current_errors if current_errors else None
            )
            mathlib_hints = self._get_mathlib_hints(
                item.statement,
                nl_proof=item.proof or item.proof_sketch,
                compiler_errors=current_errors or None,
            )
            system_parts = [_DIRECT_SYSTEM]
            # Category-specific supplement (domain-aware hints)
            cat_file = detect_math_category(item)
            cat_supplement = _load_category_supplement(cat_file)
            if cat_supplement:
                system_parts.append(cat_supplement)
            # Strategy hints from Knowledge Base (Agent 7)
            strategy_hints = self._get_strategy_hints(item)
            if strategy_hints:
                system_parts.append(strategy_hints)
            # Dependency context from Rosetta Stone (proved dependencies)
            dep_context = self._get_dependency_context(item)
            if dep_context:
                system_parts.append(dep_context)
            # Warm-start: reference proof from a similar proved theorem
            warm_start = self._get_warm_start_context(
                reference_lean, reference_name, reference_similarity,
            )
            if warm_start:
                system_parts.append(warm_start)
            if mathlib_hints:
                system_parts.append(mathlib_hints)
            if lessons:
                system_parts.append(lessons)
            system = "\n\n".join(system_parts)

            if not triples:
                prompt = _build_direct_prompt(item)
            else:
                prompt = _build_direct_retry_prompt(item, triples)

            try:
                response = complete(
                    model, prompt, system=system,
                    max_tokens=current_max_tokens, temperature=temperature,
                    cli_timeout=DIRECT_CLI_TIMEOUT,
                )
            except LLMInfraError as e:
                # Infrastructure failure (timeout, crash, auth) — don't kill
                # the item, just exhaust the direct phase and escalate.
                print(f"    Attempt {attempt_num}: INFRA ERROR — {str(e)[:80]}")
                print(f"  [Agent 6] Direct phase aborted (infra error). "
                      f"Escalating to guided mode.")
                break
            except Exception as e:
                if "context length" in str(e) or "input_tokens" in str(e):
                    print(f"    Attempt {attempt_num}: SKIP — context overflow")
                    break
                raise

            reasoning = _extract_reasoning(response)
            lean_code = _extract_lean_code(response)

            if not lean_code or not any(
                kw in lean_code
                for kw in ("theorem ", "lemma ", "def ", "instance ")
            ):
                compiled = False
                compiler_output = (
                    "error: empty or vacuous code — must contain a "
                    "theorem/lemma/def declaration"
                )
            else:
                # Pre-compiler: fix common issues before compilation
                lean_code, pre_fixes = self.pre_compiler.fix(lean_code)
                if pre_fixes:
                    print(f"    Pre-compiler: {', '.join(pre_fixes)}")

                compiled, compiler_output = self.compiler.compile(lean_code)

                # Phase 4: Try identifier repair if compilation failed
                if not compiled:
                    repair = self._try_identifier_repair(
                        lean_code, compiler_output
                    )
                    if repair is not None:
                        lean_code, compiled, compiler_output = repair

            triple = TranslationTriple(
                structured_proof=minimal,
                lean_code=lean_code,
                compiler_output=compiler_output,
                compiled=compiled,
                model=model,
                attempt_number=attempt_num,
                reasoning=reasoning,
            )
            triples.append(triple)

            if compiled:
                # Validate the target is actually proved (not axiomatized)
                valid, val_err = validate_proof_output(lean_code, item)
                if valid:
                    print(f"    Attempt {attempt_num}: SUCCESS (direct)")
                    return TranslationResult(
                        outcome=TranslationOutcome.SUCCESS,
                        lean_code=lean_code,
                        triples=triples,
                        total_attempts=len(triples),
                    )
                else:
                    # Target was axiomatized — treat as a failed attempt
                    compiled = False
                    compiler_output = f"validation error: {val_err}"
                    triple.compiled = False
                    triple.compiler_output = compiler_output
                    print(f"    Attempt {attempt_num}: REJECTED — {val_err}")

            # Classify the failure as genuine or operational
            attempt_class = classify_attempt_outcome(compiler_output, lean_code)

            if attempt_class == AttemptOutcome.OPERATIONAL and \
                    operational_retries < MAX_OPERATIONAL_RETRIES:
                operational_retries += 1
                # On truncation: increase max_tokens by 50%
                if "unexpected end of input" in compiler_output.lower():
                    current_max_tokens = int(current_max_tokens * 1.5)
                    print(f"    Attempt {attempt_num}: OPERATIONAL (truncation) "
                          f"— retrying with max_tokens={current_max_tokens}")
                # On empty code: bump temperature for diversity
                elif "empty or vacuous code" in compiler_output.lower():
                    print(f"    Attempt {attempt_num}: OPERATIONAL (empty) "
                          f"— retrying with higher temperature")
                else:
                    print(f"    Attempt {attempt_num}: OPERATIONAL "
                          f"— retrying (not counting as genuine)")
            else:
                genuine_attempts += 1
                short_err = compiler_output[:120].replace("\n", " ")
                print(f"    Attempt {attempt_num}: FAIL — {short_err}...")

        print(f"  [Agent 6] Direct phase exhausted ({len(triples)} attempts, "
              f"{genuine_attempts} genuine). Escalating to guided mode.")
        return TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            lean_code=triples[-1].lean_code if triples else None,
            triples=triples,
            total_attempts=len(triples),
        )

    def translate(
        self,
        proof: StructuredProof,
        prior_triples: list[TranslationTriple] | None = None,
        item: ExtractedItem | None = None,
    ) -> TranslationResult:
        """Translate a structured proof to Lean 4 (guided mode).

        Three-tier escalation: DeepSeek → Gemini → Decompose.
        Tiers 1-2 share a triples list, so each escalation sees the full
        history. Tier 3 decomposes into sub-lemmas and proves each independently.

        Args:
            prior_triples: failures from the direct phase to carry forward.
            item: original extracted item, used to pass the NL proof to
                prompts and for Tier 3 decomposition.
        """
        triples: list[TranslationTriple] = list(prior_triples) if prior_triples else []

        # Extract the original NL proof text (if available) for prompts.
        nl_proof = (item.proof or item.proof_sketch) if item else None

        # Tier 1: DeepSeek (full prompt, carries direct-phase failures)
        print(f"  [Agent 6] Tier 1: {self.tier1_model} "
              f"(up to {MAX_ATTEMPTS_TIER1} attempts, "
              f"carrying {len(triples)} previous attempts)")
        result = self._try_tier(
            proof, self.tier1_model, MAX_ATTEMPTS_TIER1, triples,
            max_tokens=TIER1_MAX_TOKENS, nl_proof=nl_proof, item=item,
        )
        if result is not None:
            return result

        # Tier 2: Gemini (full prompt + history from DeepSeek failures)
        print(f"  [Agent 6] Tier 1 exhausted. Escalating to Tier 2: {self.tier2_model} "
              f"(up to {MAX_ATTEMPTS_TIER2} attempts, "
              f"carrying {len(triples)} previous attempts)")
        result = self._try_tier(
            proof, self.tier2_model, MAX_ATTEMPTS_TIER2, triples,
            max_tokens=TIER2_MAX_TOKENS, nl_proof=nl_proof, item=item,
        )
        if result is not None:
            return result

        # Tier 3: Hard theorem path — decompose into sub-lemmas
        if TIER3_ENABLED and item:
            print(f"  [Agent 6] Tiers 1-2 exhausted. Escalating to Tier 3: "
                  f"decomposition ({TIER3_MODEL})")
            result = self._try_decomposed(item, triples)
            if result is not None:
                return result

        # Oracle tier: last resort with root-cause analysis
        if ORACLE_ENABLED and item:
            return self._try_oracle(item, triples)

        # All tiers exhausted
        print(f"  [Agent 6] All tiers exhausted. Flagging for human attention.")
        return TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            lean_code=triples[-1].lean_code if triples else None,
            triples=triples,
            total_attempts=len(triples),
        )

    def translate_unstructured(
        self,
        item: ExtractedItem,
        prior_triples: list[TranslationTriple] | None = None,
        reference_lean: str | None = None,
        reference_name: str | None = None,
        reference_similarity: float = 0.0,
    ) -> TranslationResult:
        """Guided escalation without a structured proof plan.

        Used when Agent 5 is skipped. Runs Tier 1/2/3 using the
        direct-phase prompt (theorem + NL proof, no plan).
        """
        triples: list[TranslationTriple] = list(prior_triples) if prior_triples else []
        nl_proof = (item.proof or item.proof_sketch) if item else None

        # Build a minimal StructuredProof just to carry the statement
        proof = StructuredProof(
            theorem_name=item.id.replace(" ", "_"),
            goal_statement=item.statement,
            strategy="direct",
            steps=[],
            dependencies=[],
            conclusion=item.statement,
        )

        # Distill direct-phase failures before entering guided mode
        distilled_history = ""
        if triples:
            print(f"  [Agent 6] Distilling {len(triples)} direct-phase attempts...")
            distilled_history = _distill_history(
                triples, self.tier1_model,
                item_statement=item.statement,
                cli_timeout=DIRECT_CLI_TIMEOUT,
            )
            if distilled_history:
                print(f"  [Agent 6] Distilled to {len(distilled_history.splitlines())} lines")

        # Tier 1
        print(f"  [Agent 6] Tier 1 (no plan): {self.tier1_model} "
              f"(up to {MAX_ATTEMPTS_TIER1} attempts, "
              f"distilled history from {len(triples)} prior attempts)")
        result = self._try_tier(
            proof, self.tier1_model, MAX_ATTEMPTS_TIER1, triples,
            max_tokens=TIER1_MAX_TOKENS, nl_proof=nl_proof, item=item,
            reference_lean=reference_lean, reference_name=reference_name,
            reference_similarity=reference_similarity,
            cli_timeout=TIER1_CLI_TIMEOUT,
            distilled_history=distilled_history,
        )
        if result is not None:
            return result

        # Distill Tier 1 failures before Tier 2
        print(f"  [Agent 6] Distilling {len(triples)} attempts before Tier 2...")
        distilled_history = _distill_history(
            triples, self.tier2_model,
            item_statement=item.statement,
            cli_timeout=DIRECT_CLI_TIMEOUT,
        )
        if distilled_history:
            print(f"  [Agent 6] Distilled to {len(distilled_history.splitlines())} lines")

        # Tier 2
        print(f"  [Agent 6] Tier 2 (no plan): "
              f"{self.tier2_model} (up to {MAX_ATTEMPTS_TIER2} attempts, "
              f"distilled history)")
        result = self._try_tier(
            proof, self.tier2_model, MAX_ATTEMPTS_TIER2, triples,
            max_tokens=TIER2_MAX_TOKENS, nl_proof=nl_proof, item=item,
            reference_lean=reference_lean, reference_name=reference_name,
            reference_similarity=reference_similarity,
            cli_timeout=TIER2_CLI_TIMEOUT,
            distilled_history=distilled_history,
        )
        if result is not None:
            return result

        # Tier 3: Decompose
        if TIER3_ENABLED:
            print(f"  [Agent 6] Tiers 1-2 exhausted. Escalating to Tier 3: "
                  f"decomposition ({TIER3_MODEL})")
            result = self._try_decomposed(item, triples)
            if result is not None:
                return result

        # Oracle tier: last resort with root-cause analysis
        if ORACLE_ENABLED:
            return self._try_oracle(item, triples)

        print(f"  [Agent 6] All tiers exhausted (no plan). Flagging for human attention.")
        return TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            lean_code=triples[-1].lean_code if triples else None,
            triples=triples,
            total_attempts=len(triples),
        )

    def _try_tier(
        self,
        proof: StructuredProof,
        model: str,
        max_attempts: int,
        triples: list[TranslationTriple],
        max_tokens: int = 8192,
        nl_proof: str | None = None,
        item: ExtractedItem | None = None,
        reference_lean: str | None = None,
        reference_name: str | None = None,
        reference_similarity: float = 0.0,
        cli_timeout: int = 1200,
        distilled_history: str = "",
    ) -> TranslationResult | None:
        """Try up to max_attempts with a given model. Returns result on success, None to escalate.

        Args:
            cli_timeout: per-tier timeout for CLI subprocess calls.
            distilled_history: compact summary of prior tier failures, replaces
                raw history in prompts to keep prompt size bounded.

        Operational failures (empty code, truncation, env issues) do not
        count against the attempt budget, up to MAX_OPERATIONAL_RETRIES.
        """
        genuine_attempts = 0
        operational_retries = 0
        current_max_tokens = max_tokens
        tier_attempt_count = 0  # how many attempts THIS tier has made (for prompt building)

        while genuine_attempts < max_attempts:
            attempt_num = len(triples) + 1

            # Temperature: 0 for first attempt, higher for retries (diversity)
            temperature = 0.0 if genuine_attempts == 0 else RETRY_TEMPERATURE

            # Cloud models: full system prompt with tuner lessons + Mathlib hints
            base_system = PROMPT_PATH.read_text(encoding="utf-8") if PROMPT_PATH.exists() else ""
            current_errors = [
                t.compiler_output for t in triples if not t.compiled and t.compiler_output
            ]
            lessons = self.tuner.get_lessons(current_errors if current_errors else None)
            mathlib_hints = self._get_mathlib_hints(
                proof.goal_statement,
                nl_proof=nl_proof,
                compiler_errors=current_errors or None,
            )
            system_parts = [base_system] if base_system else []
            # Category-specific supplement (domain-aware hints)
            if item is not None:
                cat_file = detect_math_category(item)
                cat_supplement = _load_category_supplement(cat_file)
                if cat_supplement:
                    system_parts.append(cat_supplement)
            # Strategy hints from Knowledge Base (Agent 7)
            strategy_hints = self._get_strategy_hints(item)
            if strategy_hints:
                system_parts.append(strategy_hints)
            # Dependency context from Rosetta Stone (proved dependencies)
            dep_context = self._get_dependency_context(item)
            if dep_context:
                system_parts.append(dep_context)
            # Warm-start: reference proof from a similar proved theorem
            warm_start = self._get_warm_start_context(
                reference_lean, reference_name, reference_similarity,
            )
            if warm_start:
                system_parts.append(warm_start)
            if mathlib_hints:
                system_parts.append(mathlib_hints)
            if lessons:
                system_parts.append(lessons)
            system = "\n\n".join(system_parts)

            if not triples:
                prompt = _build_initial_prompt(proof, nl_proof=nl_proof)
            elif distilled_history and tier_attempt_count == 0:
                # First attempt in this tier: use distilled summary from prior tiers
                # instead of raw history (keeps prompt bounded)
                prompt = (
                    f"Prove the following theorem in Lean 4.\n\n"
                    f"**Theorem** ({proof.theorem_name}): {proof.goal_statement}\n\n"
                )
                if nl_proof:
                    prompt += f"**Informal proof**:\n{nl_proof}\n\n"
                prompt += (
                    f"PRIOR ATTEMPTS SUMMARY (from earlier tiers — do NOT repeat these mistakes):\n\n"
                    f"{distilled_history}\n\n"
                    f"Based on the summary above, try a DIFFERENT approach.\n"
                    f"First, state your proof approach in 1-2 sentences on a line starting with "
                    f"\"APPROACH:\". Then write the Lean 4 code in a ```lean code block.\n"
                    f"Include all necessary imports at the top."
                )
            else:
                # Within-tier retries: show only this tier's attempts (compact)
                # plus distilled prior if available
                tier_triples = triples[-tier_attempt_count:] if tier_attempt_count > 0 else triples
                prompt = _build_retry_prompt(proof, tier_triples, nl_proof=nl_proof)
                if distilled_history and tier_attempt_count > 0:
                    # Prepend the distilled summary so the model has context from prior tiers
                    prompt = (
                        f"PRIOR TIERS SUMMARY:\n{distilled_history}\n\n"
                        f"CURRENT TIER ATTEMPTS:\n\n{prompt}"
                    )

            # Call LLM (catch API errors like context overflow → escalate)
            try:
                response = complete(
                    model, prompt, system=system,
                    max_tokens=current_max_tokens, temperature=temperature,
                    cli_timeout=cli_timeout,
                )
            except LLMInfraError as e:
                # Infrastructure failure (timeout, crash) — don't kill the item,
                # escalate to next tier. The model might work with a different
                # prompt size / timeout at the next tier.
                print(f"    Attempt {attempt_num}: INFRA ERROR — {str(e)[:80]}")
                print(f"    Escalating to next tier (infra error, not proof failure).")
                return None  # signal to escalate
            except Exception as e:
                err_msg = str(e)
                if "context length" in err_msg or "input_tokens" in err_msg:
                    print(f"    Attempt {attempt_num}: SKIP — context overflow, escalating")
                    return None  # escalate to next tier
                raise  # re-raise unexpected errors

            # Extract reasoning (cloud models) and code
            reasoning = _extract_reasoning(response)
            lean_code = _extract_lean_code(response)

            # Reject empty or trivially vacuous code
            if not lean_code or not any(
                kw in lean_code for kw in ("theorem ", "lemma ", "def ", "instance ")
            ):
                compiled = False
                compiler_output = (
                    "error: empty or vacuous code — must contain a theorem/lemma/def declaration"
                )
            else:
                # Pre-compiler: fix common issues before compilation
                lean_code, pre_fixes = self.pre_compiler.fix(lean_code)
                if pre_fixes:
                    print(f"    Pre-compiler: {', '.join(pre_fixes)}")

                # Compile
                compiled, compiler_output = self.compiler.compile(lean_code)

                # Phase 4: Try identifier repair if compilation failed
                if not compiled:
                    repair = self._try_identifier_repair(
                        lean_code, compiler_output
                    )
                    if repair is not None:
                        lean_code, compiled, compiler_output = repair

            # Record triple
            triple = TranslationTriple(
                structured_proof=proof,
                lean_code=lean_code,
                compiler_output=compiler_output,
                compiled=compiled,
                model=model,
                attempt_number=attempt_num,
                reasoning=reasoning,
            )
            triples.append(triple)
            tier_attempt_count += 1

            if compiled:
                # Validate the target is actually proved (not axiomatized)
                if item is not None:
                    valid, val_err = validate_proof_output(lean_code, item)
                    if not valid:
                        compiled = False
                        compiler_output = f"validation error: {val_err}"
                        triple.compiled = False
                        triple.compiler_output = compiler_output
                        print(f"    Attempt {attempt_num}: REJECTED — {val_err}")
                    else:
                        print(f"    Attempt {attempt_num}: SUCCESS")
                        return TranslationResult(
                            outcome=TranslationOutcome.SUCCESS,
                            lean_code=lean_code,
                            triples=triples,
                            total_attempts=len(triples),
                        )
                else:
                    print(f"    Attempt {attempt_num}: SUCCESS")
                    return TranslationResult(
                        outcome=TranslationOutcome.SUCCESS,
                        lean_code=lean_code,
                        triples=triples,
                        total_attempts=len(triples),
                    )

            # Classify the failure as genuine or operational
            attempt_class = classify_attempt_outcome(compiler_output, lean_code)

            if attempt_class == AttemptOutcome.OPERATIONAL and \
                    operational_retries < MAX_OPERATIONAL_RETRIES:
                operational_retries += 1
                # On truncation: increase max_tokens by 50%
                if "unexpected end of input" in compiler_output.lower():
                    current_max_tokens = int(current_max_tokens * 1.5)
                    print(f"    Attempt {attempt_num}: OPERATIONAL (truncation) "
                          f"— retrying with max_tokens={current_max_tokens}")
                # On empty code: bump temperature for diversity
                elif "empty or vacuous code" in compiler_output.lower():
                    print(f"    Attempt {attempt_num}: OPERATIONAL (empty) "
                          f"— retrying with higher temperature")
                else:
                    print(f"    Attempt {attempt_num}: OPERATIONAL "
                          f"— retrying (not counting as genuine)")
            else:
                genuine_attempts += 1
                # Truncate long compiler output for display
                short_err = compiler_output[:120].replace("\n", " ")
                print(f"    Attempt {attempt_num}: FAIL — {short_err}...")

        return None  # signal to escalate

    # ------------------------------------------------------------------
    # Tier 3: Hard theorem decomposition
    # ------------------------------------------------------------------

    def _try_decomposed(
        self,
        item: ExtractedItem,
        prior_triples: list[TranslationTriple],
    ) -> TranslationResult | None:
        """Axiom-first decomposition: validate structure, then delegate sub-lemmas.

        1. Decompose theorem into sub-lemmas via LLM
        2. Axiomatize all sub-lemmas (declare as `axiom` in Lean 4)
        3. Try to assemble the main theorem using axiomatized sub-lemmas
        4. If assembly compiles → return DECOMPOSED with sub-lemma list
           (pipeline creates backlog entries so each gets full 16 attempts)
        5. If assembly fails → decomposition structure is wrong, return None
        """
        # Step 1: Call the decomposer
        decomposer_system = ""
        if DECOMPOSER_PROMPT_PATH.exists():
            decomposer_system = DECOMPOSER_PROMPT_PATH.read_text(encoding="utf-8")

        decomp_prompt = _build_decomposition_prompt(item, prior_triples)

        try:
            decomp_data = complete_json(
                TIER3_MODEL, decomp_prompt,
                system=decomposer_system,
                max_tokens=TIER3_MAX_TOKENS,
                retries=2,
            )
        except Exception as e:
            print(f"  [Tier 3] Decomposition failed: {e}")
            return None

        try:
            decomp = _parse_decomposition(decomp_data)
        except Exception as e:
            print(f"  [Tier 3] Failed to parse decomposition: {e}")
            return None

        if not decomp.sub_lemmas:
            print(f"  [Tier 3] Decomposer produced no sub-lemmas.")
            return None

        print(f"  [Tier 3] Decomposed into {len(decomp.sub_lemmas)} sub-lemmas: "
              f"{', '.join(sl.name for sl in decomp.sub_lemmas)}")

        # Step 2: Try assembly with axiomatized sub-lemmas
        all_triples: list[TranslationTriple] = list(prior_triples)
        minimal = _minimal_proof(item)
        assembly_prompt = _build_axiom_assembly_prompt(decomp, item)

        print(f"  [Tier 3] Assembling with axiomatized sub-lemmas...")

        for attempt in range(TIER3_ATTEMPTS_PER_LEMMA):
            attempt_num = len(all_triples) + 1
            temperature = 0.0 if attempt == 0 else RETRY_TEMPERATURE

            try:
                response = complete(
                    TIER3_PROVER_MODEL, assembly_prompt,
                    system=_DIRECT_SYSTEM,
                    max_tokens=TIER3_MAX_TOKENS,
                    temperature=temperature,
                )
            except Exception as e:
                print(f"    Assembly attempt {attempt + 1}: ERROR — {e}")
                break

            lean_code = _extract_lean_code(response)
            reasoning = _extract_reasoning(response)

            if not lean_code or not any(
                kw in lean_code
                for kw in ("theorem ", "lemma ", "def ", "instance ", "axiom ")
            ):
                compiled = False
                compiler_output = (
                    "error: empty or vacuous code — must contain a "
                    "theorem/lemma/def declaration"
                )
            else:
                # Run pre-compiler on assembly code (same as Tiers 1-2)
                if self.pre_compiler:
                    lean_code, pc_fixes = self.pre_compiler.fix(lean_code)
                    if pc_fixes:
                        print(f"    Pre-compiler: {', '.join(pc_fixes)}")
                compiled, compiler_output = self.compiler.compile(lean_code)

            triple = TranslationTriple(
                structured_proof=minimal,
                lean_code=lean_code,
                compiler_output=compiler_output,
                compiled=compiled,
                model=f"{TIER3_PROVER_MODEL} [axiom-assembly]",
                attempt_number=attempt_num,
                reasoning=reasoning or "Axiom-first assembly",
            )
            all_triples.append(triple)

            if compiled:
                print(f"    Assembly attempt {attempt + 1}: SUCCESS (axiom-first)")
                print(f"  [Tier 3] Structure validated. "
                      f"{len(decomp.sub_lemmas)} sub-lemmas → backlog.")
                return TranslationResult(
                    outcome=TranslationOutcome.DECOMPOSED,
                    lean_code=lean_code,
                    triples=all_triples,
                    total_attempts=len(all_triples),
                    sub_lemmas=decomp.sub_lemmas,
                )
            else:
                short_err = compiler_output[:100].replace("\n", " ")
                print(f"    Assembly attempt {attempt + 1}: FAIL — {short_err}...")
                assembly_prompt = (
                    f"{_build_axiom_assembly_prompt(decomp, item)}\n\n"
                    f"Previous assembly attempt failed:\n```lean\n{lean_code}\n```\n"
                    f"Error: {compiler_output[:400]}\n\n"
                    f"Fix the error and try again."
                )

        print(f"  [Tier 3] Axiom-first assembly failed after "
              f"{TIER3_ATTEMPTS_PER_LEMMA} attempts. "
              f"Decomposition structure is invalid.")
        # Preserve assembly triples so total_attempts is accurate and
        # failure records include assembly error info.
        prior_triples.extend(all_triples[len(prior_triples):])
        return None

    # ------------------------------------------------------------------
    # Oracle tier: last resort for hard theorems
    # ------------------------------------------------------------------

    def _try_oracle(
        self,
        item: ExtractedItem,
        all_triples: list[TranslationTriple],
    ) -> TranslationResult:
        """Oracle tier: root-cause analysis + stronger model as last resort.

        Uses a configurable oracle model (default: Claude Sonnet) to analyze
        ALL prior failure triples, identify the root cause, and try a
        fundamentally different approach.

        Unlike _try_tier(), this always returns a TranslationResult (never None),
        because there is no further escalation.

        Args:
            item: the original extracted item (theorem + NL proof).
            all_triples: ALL prior triples from direct + guided + decomposition.

        Returns:
            TranslationResult with outcome ORACLE_SUCCESS or NEEDS_HUMAN.
        """
        print(f"  [Agent 6] Oracle tier: {ORACLE_MODEL} "
              f"(up to {ORACLE_MAX_ATTEMPTS} attempts, "
              f"analyzing {len(all_triples)} prior failures)")

        minimal = _minimal_proof(item)
        oracle_triples: list[TranslationTriple] = list(all_triples)

        # Build system prompt: oracle system + category supplement + Mathlib hints
        system_parts = [_ORACLE_SYSTEM]
        cat_file = detect_math_category(item)
        cat_supplement = _load_category_supplement(cat_file)
        if cat_supplement:
            system_parts.append(cat_supplement)

        # Gather all compiler errors for Mathlib hint search
        all_errors = [
            t.compiler_output for t in all_triples
            if not t.compiled and t.compiler_output
        ]
        mathlib_hints = self._get_mathlib_hints(
            item.statement,
            nl_proof=item.proof or item.proof_sketch,
            compiler_errors=all_errors or None,
        )
        if mathlib_hints:
            system_parts.append(mathlib_hints)

        # Tuner lessons based on all prior errors
        lessons = self.tuner.get_lessons(all_errors if all_errors else None)
        if lessons:
            system_parts.append(lessons)

        system = "\n\n".join(system_parts)

        genuine_attempts = 0
        operational_retries = 0
        current_max_tokens = ORACLE_MAX_TOKENS
        winning_analysis = None

        while genuine_attempts < ORACLE_MAX_ATTEMPTS:
            attempt_num = len(oracle_triples) + 1
            # Temperature: 0.0 for first attempt, 0.7 for retries
            temperature = 0.0 if genuine_attempts == 0 else 0.7

            # First attempt uses the full oracle prompt; retries add oracle-
            # phase failures on top of the original oracle prompt.
            if genuine_attempts == 0:
                prompt = _build_oracle_prompt(item, all_triples)
            else:
                # Rebuild with oracle-phase failures appended
                prompt = _build_oracle_prompt(item, oracle_triples)

            try:
                response = complete(
                    ORACLE_MODEL, prompt, system=system,
                    max_tokens=current_max_tokens, temperature=temperature,
                )
            except LLMInfraError as e:
                print(f"    Oracle attempt {genuine_attempts + 1}: "
                      f"INFRA ERROR — {str(e)[:80]}")
                raise
            except Exception as e:
                err_msg = str(e)
                if "context length" in err_msg or "input_tokens" in err_msg:
                    print(f"    Oracle attempt {genuine_attempts + 1}: "
                          f"SKIP — context overflow")
                    break
                raise

            reasoning = _extract_reasoning(response)
            analysis = _extract_oracle_analysis(response)
            lean_code = _extract_lean_code(response)

            if not lean_code or not any(
                kw in lean_code
                for kw in ("theorem ", "lemma ", "def ", "instance ")
            ):
                compiled = False
                compiler_output = (
                    "error: empty or vacuous code — must contain a "
                    "theorem/lemma/def declaration"
                )
            else:
                # Pre-compiler fixes
                lean_code, pre_fixes = self.pre_compiler.fix(lean_code)
                if pre_fixes:
                    print(f"    Pre-compiler: {', '.join(pre_fixes)}")

                compiled, compiler_output = self.compiler.compile(lean_code)

                # Try identifier repair
                if not compiled:
                    repair = self._try_identifier_repair(
                        lean_code, compiler_output
                    )
                    if repair is not None:
                        lean_code, compiled, compiler_output = repair

            triple = TranslationTriple(
                structured_proof=minimal,
                lean_code=lean_code,
                compiler_output=compiler_output,
                compiled=compiled,
                model=f"{ORACLE_MODEL} [oracle]",
                attempt_number=attempt_num,
                reasoning=reasoning or (analysis[:200] if analysis else ""),
            )
            oracle_triples.append(triple)

            if compiled:
                # Validate the target is actually proved (not axiomatized)
                valid, val_err = validate_proof_output(lean_code, item)
                if not valid:
                    compiled = False
                    compiler_output = f"validation error: {val_err}"
                    triple.compiled = False
                    triple.compiler_output = compiler_output
                    print(f"    Oracle attempt {genuine_attempts + 1}: "
                          f"REJECTED — {val_err}")
                else:
                    winning_analysis = analysis
                    print(f"    Oracle attempt {genuine_attempts + 1}: "
                          f"SUCCESS (oracle)")
                    return TranslationResult(
                        outcome=TranslationOutcome.ORACLE_SUCCESS,
                        lean_code=lean_code,
                        triples=oracle_triples,
                        total_attempts=len(oracle_triples),
                        oracle_analysis=winning_analysis,
                    )

            # Classify the failure
            attempt_class = classify_attempt_outcome(compiler_output, lean_code)

            if attempt_class == AttemptOutcome.OPERATIONAL and \
                    operational_retries < MAX_OPERATIONAL_RETRIES:
                operational_retries += 1
                if "unexpected end of input" in compiler_output.lower():
                    current_max_tokens = int(current_max_tokens * 1.5)
                    print(f"    Oracle attempt {genuine_attempts + 1}: "
                          f"OPERATIONAL (truncation) — retrying with "
                          f"max_tokens={current_max_tokens}")
                else:
                    print(f"    Oracle attempt {genuine_attempts + 1}: "
                          f"OPERATIONAL — retrying")
            else:
                genuine_attempts += 1
                short_err = compiler_output[:120].replace("\n", " ")
                print(f"    Oracle attempt {genuine_attempts}: "
                      f"FAIL — {short_err}...")

        print(f"  [Agent 6] Oracle tier exhausted "
              f"({len(oracle_triples) - len(all_triples)} oracle attempts). "
              f"Flagging for human attention.")
        return TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            lean_code=oracle_triples[-1].lean_code if oracle_triples else None,
            triples=oracle_triples,
            total_attempts=len(oracle_triples),
        )

    # ------------------------------------------------------------------
    # Definition formalization
    # ------------------------------------------------------------------

    def translate_definition(
        self,
        item: ExtractedItem,
    ) -> TranslationResult:
        """Formalize a mathematical definition into Lean 4.

        Simpler than theorem translation: 3 direct attempts with the
        primary model, then 3 escalation attempts with the escalation
        model. No decomposition or oracle tier.

        Budget: DEFINITION_MAX_ATTEMPTS (default 6), split evenly
        between the primary and escalation models.
        """
        max_attempts = DEFINITION_MAX_ATTEMPTS
        direct_budget = max_attempts // 2  # 3 by default
        escalation_budget = max_attempts - direct_budget  # 3 by default

        # Load definition-specific system prompt
        if DEFINITION_PROMPT_PATH.exists():
            base_system = DEFINITION_PROMPT_PATH.read_text(encoding="utf-8")
        else:
            base_system = ""

        minimal = _minimal_proof(item)
        triples: list[TranslationTriple] = []

        # Detect category once for supplements
        _item_cat_file = detect_math_category(item)
        if _item_cat_file:
            cat_label = _item_cat_file.replace(".md", "")
            print(f"  [Agent 6] Definition phase: {DEFINITION_MODEL} "
                  f"(up to {direct_budget} attempts, "
                  f"category={cat_label})")
        else:
            print(f"  [Agent 6] Definition phase: {DEFINITION_MODEL} "
                  f"(up to {direct_budget} attempts)")

        # Phase 1: Direct attempts with primary model
        result = self._try_definition_tier(
            item, DEFINITION_MODEL, direct_budget, triples,
            base_system=base_system,
        )
        if result is not None:
            return result

        # Phase 2: Escalation attempts with escalation model
        print(f"  [Agent 6] Definition escalating to: "
              f"{DEFINITION_ESCALATION_MODEL} "
              f"(up to {escalation_budget} attempts, "
              f"carrying {len(triples)} previous attempts)")
        result = self._try_definition_tier(
            item, DEFINITION_ESCALATION_MODEL, escalation_budget, triples,
            base_system=base_system,
        )
        if result is not None:
            return result

        # All attempts exhausted
        print(f"  [Agent 6] Definition formalization exhausted "
              f"({len(triples)} attempts). Flagging for human attention.")
        return TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            lean_code=triples[-1].lean_code if triples else None,
            triples=triples,
            total_attempts=len(triples),
        )

    def _try_definition_tier(
        self,
        item: ExtractedItem,
        model: str,
        max_attempts: int,
        triples: list[TranslationTriple],
        base_system: str = "",
    ) -> TranslationResult | None:
        """Try up to max_attempts to formalize a definition.

        Returns TranslationResult on success, None to escalate.
        """
        genuine_attempts = 0
        operational_retries = 0
        current_max_tokens = DEFINITION_MAX_TOKENS
        minimal = _minimal_proof(item)

        while genuine_attempts < max_attempts:
            attempt_num = len(triples) + 1
            temperature = 0.0 if genuine_attempts == 0 else RETRY_TEMPERATURE

            # Build system prompt: base + category supplement + Mathlib hints + lessons
            current_errors = [
                t.compiler_output for t in triples
                if not t.compiled and t.compiler_output
            ]
            lessons = self.tuner.get_lessons(
                current_errors if current_errors else None
            )
            mathlib_hints = self._get_mathlib_hints(
                item.statement,
                nl_proof=item.proof or item.proof_sketch,
                compiler_errors=current_errors or None,
            )
            system_parts = [base_system] if base_system else []
            cat_file = detect_math_category(item)
            cat_supplement = _load_category_supplement(cat_file)
            if cat_supplement:
                system_parts.append(cat_supplement)
            if mathlib_hints:
                system_parts.append(mathlib_hints)
            if lessons:
                system_parts.append(lessons)
            system = "\n\n".join(system_parts)

            if not triples:
                prompt = _build_definition_prompt(item)
            else:
                prompt = _build_definition_retry_prompt(item, triples)

            try:
                response = complete(
                    model, prompt, system=system,
                    max_tokens=current_max_tokens, temperature=temperature,
                )
            except Exception as e:
                if "context length" in str(e) or "input_tokens" in str(e):
                    print(f"    Attempt {attempt_num}: SKIP — context overflow")
                    return None  # escalate
                raise

            reasoning = _extract_construct(response) or _extract_reasoning(response)
            lean_code = _extract_lean_code(response)

            # For definitions, accept a wider range of declarations
            valid_keywords = (
                "def ", "noncomputable def ", "structure ", "class ",
                "instance ", "abbrev ", "theorem ", "lemma ",
            )
            if not lean_code or not any(kw in lean_code for kw in valid_keywords):
                compiled = False
                compiler_output = (
                    "error: empty or vacuous code — must contain a "
                    "def/structure/class/instance/abbrev declaration"
                )
            else:
                # Pre-compiler fixes
                lean_code, pre_fixes = self.pre_compiler.fix(lean_code)
                if pre_fixes:
                    print(f"    Pre-compiler: {', '.join(pre_fixes)}")

                compiled, compiler_output = self.compiler.compile(lean_code)

                # Try identifier repair
                if not compiled:
                    repair = self._try_identifier_repair(
                        lean_code, compiler_output
                    )
                    if repair is not None:
                        lean_code, compiled, compiler_output = repair

            triple = TranslationTriple(
                structured_proof=minimal,
                lean_code=lean_code,
                compiler_output=compiler_output,
                compiled=compiled,
                model=model,
                attempt_number=attempt_num,
                reasoning=reasoning,
            )
            triples.append(triple)

            if compiled:
                # Validate the target is a real definition (not axiomatized)
                valid, val_err = validate_proof_output(
                    lean_code, item, is_definition=True,
                )
                if not valid:
                    compiled = False
                    compiler_output = f"validation error: {val_err}"
                    triple.compiled = False
                    triple.compiler_output = compiler_output
                    print(f"    Attempt {attempt_num}: REJECTED — {val_err}")
                else:
                    print(f"    Attempt {attempt_num}: SUCCESS (definition)")
                    return TranslationResult(
                        outcome=TranslationOutcome.DEFINITION_SUCCESS,
                        lean_code=lean_code,
                        triples=triples,
                        total_attempts=len(triples),
                    )

            # Classify failure
            attempt_class = classify_attempt_outcome(compiler_output, lean_code)

            if attempt_class == AttemptOutcome.OPERATIONAL and \
                    operational_retries < MAX_OPERATIONAL_RETRIES:
                operational_retries += 1
                if "unexpected end of input" in compiler_output.lower():
                    current_max_tokens = int(current_max_tokens * 1.5)
                    print(f"    Attempt {attempt_num}: OPERATIONAL (truncation) "
                          f"— retrying with max_tokens={current_max_tokens}")
                elif "empty or vacuous code" in compiler_output.lower():
                    print(f"    Attempt {attempt_num}: OPERATIONAL (empty) "
                          f"— retrying with higher temperature")
                else:
                    print(f"    Attempt {attempt_num}: OPERATIONAL "
                          f"— retrying (not counting as genuine)")
            else:
                genuine_attempts += 1
                short_err = compiler_output[:120].replace("\n", " ")
                print(f"    Attempt {attempt_num}: FAIL — {short_err}...")

        return None  # signal to escalate
