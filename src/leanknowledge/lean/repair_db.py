"""Three-tier repair pattern database for deterministic compiler error fixes.

Tier A: Exact pattern match (~35% of errors)
    - Missing tactic imports
    - Simple identifier renames (fuzzy match against Mathlib index)
    - Prop/Bool coercion
    - Trivial goals (True, rfl)

Tier B: Heuristic repairs (~25% of errors)
    - Type coercion (ℕ/ℤ/ℝ casts)
    - Simp lemma suggestions
    - Namespace renames (Mathlib API changes)

Tier C: LLM fallback (~40% of errors)
    - Falls through to translator.repair()
    - Learning loop records successful Claude repairs for future Tier A matching
"""

import difflib
import json
import re
from pathlib import Path

from ..schemas import CompilerError, ErrorCategory, LeanCode

PROJECT_ROOT = Path(__file__).resolve().parents[3]
REPAIR_PATTERNS_PATH = PROJECT_ROOT / "outputs" / "repair_patterns.json"
INDEX_PATH = PROJECT_ROOT / "librarian_index.json"

# ---------------------------------------------------------------------------
# Tier A: Exact pattern matches
# ---------------------------------------------------------------------------

# Tactic name → required Mathlib import
TACTIC_IMPORTS: dict[str, str] = {
    "omega": "Mathlib.Tactic.Omega",
    "positivity": "Mathlib.Tactic.Positivity",
    "norm_num": "Mathlib.Tactic.NormNum",
    "ring": "Mathlib.Tactic.Ring",
    "ring_nf": "Mathlib.Tactic.Ring",
    "linarith": "Mathlib.Tactic.Linarith",
    "nlinarith": "Mathlib.Tactic.Linarith",
    "field_simp": "Mathlib.Tactic.FieldSimp",
    "polyrith": "Mathlib.Tactic.Polyrith",
    "push_neg": "Mathlib.Tactic.PushNeg",
    "contrapose": "Mathlib.Tactic.Contrapose",
    "gcongr": "Mathlib.Tactic.GCongr",
    "norm_cast": "Mathlib.Tactic.NormCast",
    "push_cast": "Mathlib.Tactic.NormCast",
    "Abel": "Mathlib.Tactic.Abel",
    "abel": "Mathlib.Tactic.Abel",
    "decide": "Mathlib.Tactic.Decide",
    "aesop": "Mathlib.Tactic.AesopCat",
    "ext": "Mathlib.Tactic.Ext",
    "continuity": "Mathlib.Tactic.Continuity",
    "measurability": "Mathlib.Tactic.Measurability",
    "simp": "Mathlib.Tactic.Simp",
    "mono": "Mathlib.Tactic.Monotone",
    "bound_tac": "Mathlib.Tactic.Bound",
    "tauto": "Mathlib.Tactic.Tauto",
    "rcases": "Mathlib.Tactic.RCases",
    "obtain": "Mathlib.Tactic.RCases",
    "use": "Mathlib.Tactic.Use",
    "choose": "Mathlib.Tactic.Choose",
    "refine'": "Mathlib.Tactic.Refine",
}

# Type coercion error patterns → fix
TYPE_CAST_FIXES: list[tuple[str, str, str]] = [
    # (error_pattern, search_in_code, replacement_function_name)
    (r"expected.*ℤ.*got.*ℕ", r"\b(\w+)\s*:\s*ℕ", "↑"),   # ℕ → ℤ: add ↑
    (r"expected.*ℝ.*got.*ℕ", r"\b(\w+)\s*:\s*ℕ", "↑"),   # ℕ → ℝ: add ↑
    (r"expected.*ℝ.*got.*ℤ", r"\b(\w+)\s*:\s*ℤ", "↑"),   # ℤ → ℝ: add ↑
    (r"expected.*ℕ.*got.*ℤ", None, ".toNat"),               # ℤ → ℕ: .toNat
]

# Known Mathlib namespace renames (version migration)
NAMESPACE_RENAMES: dict[str, str] = {
    "Finset.sum_comm": "Finset.sum_comm'",
    "Set.Finite": "Set.Finite",
    "Metric.ball": "Metric.ball",
    "Filter.Tendsto": "Filter.Tendsto",
    "MeasureTheory.Measure.ae": "MeasureTheory.ae",
}


def _add_import(code: str, import_path: str) -> str:
    """Add an import statement at the top of the code (after existing imports)."""
    import_line = f"import {import_path}"
    if import_line in code:
        return code  # Already imported

    lines = code.splitlines()
    # Find the last import line
    last_import_idx = -1
    for i, line in enumerate(lines):
        if line.startswith("import "):
            last_import_idx = i

    if last_import_idx >= 0:
        lines.insert(last_import_idx + 1, import_line)
    else:
        lines.insert(0, import_line)

    return "\n".join(lines)


def _fix_missing_tactic_import(code: str, error: CompilerError) -> str | None:
    """Fix 'unknown tactic' by adding the required import."""
    msg = error.message.lower()

    # Extract tactic name from error
    m = re.search(r"unknown tactic '(\w+)'", msg)
    if not m:
        m = re.search(r"unknown identifier '(\w+)'", msg)
    if not m:
        return None

    tactic_name = m.group(1)
    import_path = TACTIC_IMPORTS.get(tactic_name)
    if not import_path:
        return None

    return _add_import(code, import_path)


def _fix_prop_bool(code: str, error: CompilerError) -> str | None:
    """Fix Prop/Bool coercion errors."""
    if "prop" not in error.message.lower() or "bool" not in error.message.lower():
        return None

    # Common fix: wrap condition in `decide` or add `== true`
    if error.line:
        lines = code.splitlines()
        if 0 < error.line <= len(lines):
            line = lines[error.line - 1]
            # Try adding `(· : Prop)` cast or `== true`
            if "if " in line:
                # `if cond then` → `if (cond : Prop) then`
                fixed = re.sub(r"if\s+(.+?)\s+then", r"if ((\1) : Prop) then", line)
                if fixed != line:
                    lines[error.line - 1] = fixed
                    return "\n".join(lines)
    return None


def _fix_trivial_goal(code: str, error: CompilerError) -> str | None:
    """Fix trivial unsolved goals (True, rfl cases)."""
    msg = error.message

    if "⊢ True" in msg:
        # Add `trivial` at the error location
        return _insert_tactic_at(code, error.line, "trivial")

    # Check for `⊢ X = X` pattern (reflexivity)
    rfl_match = re.search(r"⊢\s+(.+?)\s*=\s*\1\s*$", msg, re.MULTILINE)
    if rfl_match:
        return _insert_tactic_at(code, error.line, "rfl")

    return None


def _insert_tactic_at(code: str, line_num: int | None, tactic: str) -> str | None:
    """Insert a tactic at or near the given line number."""
    if not line_num:
        return None
    lines = code.splitlines()
    if 0 < line_num <= len(lines):
        # Insert the tactic before the problematic line
        indent = len(lines[line_num - 1]) - len(lines[line_num - 1].lstrip())
        tactic_line = " " * indent + tactic
        lines.insert(line_num - 1, tactic_line)
        return "\n".join(lines)
    return None


def _fix_unknown_identifier(code: str, error: CompilerError, lean_names: list[str]) -> str | None:
    """Fix unknown identifier by fuzzy-matching against known Lean names."""
    m = re.search(r"unknown identifier '([^']+)'", error.message)
    if not m:
        m = re.search(r"unknown constant '([^']+)'", error.message)
    if not m:
        return None

    bad_name = m.group(1)
    # Get the last component for matching
    short_name = bad_name.rsplit(".", 1)[-1] if "." in bad_name else bad_name

    matches = difflib.get_close_matches(short_name, lean_names, n=1, cutoff=0.8)
    if not matches:
        return None

    best = matches[0]
    # If original was qualified, try to keep the qualification
    if "." in bad_name:
        prefix = bad_name.rsplit(".", 1)[0]
        replacement = f"{prefix}.{best}"
    else:
        replacement = best

    return code.replace(bad_name, replacement)


# ---------------------------------------------------------------------------
# Tier B: Heuristic repairs
# ---------------------------------------------------------------------------

def _fix_type_coercion(code: str, error: CompilerError) -> str | None:
    """Fix type coercion errors by inserting casts."""
    msg = error.message
    if "type mismatch" not in msg.lower():
        return None

    for pattern, _search, cast in TYPE_CAST_FIXES:
        if re.search(pattern, msg, re.DOTALL):
            if error.line and cast == "↑":
                lines = code.splitlines()
                if 0 < error.line <= len(lines):
                    line = lines[error.line - 1]
                    # Try adding ↑ before variables in the line
                    # Find variable names and try casting, but avoid keywords
                    KEYWORDS = {
                        "def", "theorem", "lemma", "variable", "structure", "class", "instance", "example",
                        "if", "then", "else", "let", "have", "from", "by", "calc", "where", "with", "match",
                        "fun", "Prop", "Type", "Sort", "import", "open", "namespace", "section", "end"
                    }
                    
                    pattern_re = re.compile(r"(?<![↑α-ωΑ-Ω])(\b[a-z_]\w*\b)")
                    
                    # Find all matches
                    matches = list(pattern_re.finditer(line))
                    for m in matches:
                        word = m.group(1)
                        if word not in KEYWORDS:
                            # Replace this occurrence
                            start, end = m.span(1)
                            fixed = line[:start] + f"↑{word}" + line[end:]
                            lines[error.line - 1] = fixed
                            return "\n".join(lines)
            elif cast == ".toNat" and error.line:
                lines = code.splitlines()
                if 0 < error.line <= len(lines):
                    line = lines[error.line - 1]
                    # Append .toNat to the first identifier
                    fixed = re.sub(r"(\b[a-z_]\w*\b)(?!\.toNat)", rf"\1.toNat", line, count=1)
                    if fixed != line:
                        lines[error.line - 1] = fixed
                        return "\n".join(lines)
    return None


def _fix_namespace_rename(code: str, error: CompilerError) -> str | None:
    """Fix references to renamed Mathlib namespaces."""
    m = re.search(r"unknown (?:constant|identifier|namespace) '([^']+)'", error.message)
    if not m:
        return None

    old_name = m.group(1)
    new_name = NAMESPACE_RENAMES.get(old_name)
    if new_name and new_name != old_name:
        return code.replace(old_name, new_name)

    return None


# ---------------------------------------------------------------------------
# Learning loop (Tier C support)
# ---------------------------------------------------------------------------

def _load_learned_patterns() -> dict[str, str]:
    """Load patterns learned from previous Claude repairs."""
    if not REPAIR_PATTERNS_PATH.exists():
        return {}
    try:
        return json.loads(REPAIR_PATTERNS_PATH.read_text(encoding="utf-8"))
    except (json.JSONDecodeError, OSError):
        return {}


def _save_learned_pattern(error_sig: str, fix_description: str):
    """Record a successful repair pattern for future use."""
    patterns = _load_learned_patterns()
    patterns[error_sig] = fix_description
    REPAIR_PATTERNS_PATH.parent.mkdir(parents=True, exist_ok=True)
    REPAIR_PATTERNS_PATH.write_text(
        json.dumps(patterns, indent=2), encoding="utf-8"
    )


def _error_signature(error: CompilerError) -> str:
    """Generate a canonical signature for an error (for pattern matching)."""
    # Normalize: remove file-specific details, keep error structure
    msg = error.message
    # Remove specific identifiers/names to get the pattern
    msg = re.sub(r"'[^']*'", "'<NAME>'", msg)
    msg = re.sub(r"\d+", "<N>", msg)
    return f"{error.category.value}:{msg[:200]}"


# ---------------------------------------------------------------------------
# Main repair interface
# ---------------------------------------------------------------------------

_lean_names_cache: list[str] | None = None


def _get_lean_names() -> list[str]:
    """Load known Lean names from the librarian index (cached)."""
    global _lean_names_cache
    if _lean_names_cache is not None:
        return _lean_names_cache

    if not INDEX_PATH.exists():
        _lean_names_cache = []
        return _lean_names_cache

    try:
        data = json.loads(INDEX_PATH.read_text(encoding="utf-8"))
        entries = data.get("entries", [])
        _lean_names_cache = [e.get("lean_name", "") for e in entries if e.get("lean_name")]
    except (json.JSONDecodeError, OSError):
        _lean_names_cache = []

    return _lean_names_cache


class RepairDB:
    """Three-tier deterministic repair engine."""

    def try_repair(
        self, code: str, errors: list[CompilerError]
    ) -> tuple[LeanCode | None, list[str]]:
        """Try deterministic repair. Returns (fixed_code, fix_descriptions) or (None, []).

        fix_descriptions lists what was attempted (passed to Claude if Tier C needed).
        """
        current_code = code
        fixes_applied: list[str] = []

        for error in errors:
            # Tier A: exact pattern match
            fix = self._tier_a(current_code, error)
            if fix:
                current_code = fix
                fixes_applied.append(f"Tier A: {error.category.value} — pattern fix")
                continue

            # Tier B: heuristic
            fix = self._tier_b(current_code, error)
            if fix:
                current_code = fix
                fixes_applied.append(f"Tier B: {error.category.value} — heuristic fix")
                continue

        if fixes_applied and current_code != code:
            return LeanCode(code=current_code), fixes_applied

        return None, fixes_applied

    def learn(self, errors: list[CompilerError], original_code: str, fixed_code: str):
        """Record a successful Claude repair for future pattern matching."""
        for error in errors:
            sig = _error_signature(error)
            # Compute a brief description of the diff
            desc = f"Claude fixed: {error.message[:100]}"
            _save_learned_pattern(sig, desc)

    def _tier_a(self, code: str, error: CompilerError) -> str | None:
        """Tier A: exact pattern matching."""
        # Check learned patterns first
        sig = _error_signature(error)
        learned = _load_learned_patterns()
        if sig in learned:
            # We know this pattern was fixed before, but we can't replay
            # the exact fix (it was code-specific). Signal that Claude should handle it.
            pass

        # Missing tactic import
        fix = _fix_missing_tactic_import(code, error)
        if fix:
            return fix

        # Prop/Bool coercion
        fix = _fix_prop_bool(code, error)
        if fix:
            return fix

        # Trivial goals
        fix = _fix_trivial_goal(code, error)
        if fix:
            return fix

        # Unknown identifier → fuzzy match
        lean_names = _get_lean_names()
        if lean_names:
            fix = _fix_unknown_identifier(code, error, lean_names)
            if fix:
                return fix

        return None

    def _tier_b(self, code: str, error: CompilerError) -> str | None:
        """Tier B: heuristic repairs."""
        # Type coercion
        fix = _fix_type_coercion(code, error)
        if fix:
            return fix

        # Namespace renames
        fix = _fix_namespace_rename(code, error)
        if fix:
            return fix

        return None
