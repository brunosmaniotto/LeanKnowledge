"""Three-tier deterministic repair engine for Lean 4 compiler errors.

Tier A: Exact pattern match (~35% of errors)
    - Missing tactic imports
    - Prop/Bool coercion
    - Trivial goals (True, rfl)
    - Unknown identifier fuzzy match

Tier B: Heuristic repairs (~25% of errors)
    - Type coercion (nat/int/real casts)
    - Namespace renames (Mathlib API changes)

Tier C: LLM fallback (~40% of errors)
    - Falls through to the translator's retry loop
"""

import difflib
import re

from ..schemas import CompilerError, ErrorCategory

# ---------------------------------------------------------------------------
# Tier A: Exact pattern matches
# ---------------------------------------------------------------------------

# Tactic name -> required Mathlib import
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
    "abel": "Mathlib.Tactic.Abel",
    "decide": "Mathlib.Tactic.Decide",
    "aesop": "Mathlib.Tactic.AesopCat",
    "ext": "Mathlib.Tactic.Ext",
    "continuity": "Mathlib.Tactic.Continuity",
    "measurability": "Mathlib.Tactic.Measurability",
    "simp": "Mathlib.Tactic.Simp",
    "mono": "Mathlib.Tactic.Monotone",
    "tauto": "Mathlib.Tactic.Tauto",
    "rcases": "Mathlib.Tactic.RCases",
    "obtain": "Mathlib.Tactic.RCases",
    "use": "Mathlib.Tactic.Use",
    "choose": "Mathlib.Tactic.Choose",
}

# Type coercion error patterns
TYPE_CAST_FIXES: list[tuple[str, str]] = [
    (r"expected.*ℤ.*got.*ℕ", "↑"),
    (r"expected.*ℝ.*got.*ℕ", "↑"),
    (r"expected.*ℝ.*got.*ℤ", "↑"),
    (r"expected.*ℕ.*got.*ℤ", ".toNat"),
]

# Known Mathlib namespace renames
NAMESPACE_RENAMES: dict[str, str] = {
    "Finset.sum_comm": "Finset.sum_comm'",
    "MeasureTheory.Measure.ae": "MeasureTheory.ae",
}


# ---------------------------------------------------------------------------
# Tier A helpers
# ---------------------------------------------------------------------------

def _add_import(code: str, import_path: str) -> str:
    """Add an import statement after existing imports."""
    import_line = f"import {import_path}"
    if import_line in code:
        return code

    lines = code.splitlines()
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
    msg = error.message.lower()

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
    if "prop" not in error.message.lower() or "bool" not in error.message.lower():
        return None

    if error.line:
        lines = code.splitlines()
        if 0 < error.line <= len(lines):
            line = lines[error.line - 1]
            if "if " in line:
                fixed = re.sub(
                    r"if\s+(.+?)\s+then", r"if ((\1) : Prop) then", line
                )
                if fixed != line:
                    lines[error.line - 1] = fixed
                    return "\n".join(lines)
    return None


def _fix_trivial_goal(code: str, error: CompilerError) -> str | None:
    msg = error.message

    if "\u22a2 True" in msg:  # ⊢ True
        return _insert_tactic_at(code, error.line, "trivial")

    rfl_match = re.search(r"\u22a2\s+(.+?)\s*=\s*\1\s*$", msg, re.MULTILINE)
    if rfl_match:
        return _insert_tactic_at(code, error.line, "rfl")

    return None


def _insert_tactic_at(code: str, line_num: int | None, tactic: str) -> str | None:
    if not line_num:
        return None
    lines = code.splitlines()
    if 0 < line_num <= len(lines):
        indent = len(lines[line_num - 1]) - len(lines[line_num - 1].lstrip())
        tactic_line = " " * indent + tactic
        lines.insert(line_num - 1, tactic_line)
        return "\n".join(lines)
    return None


def _fix_unknown_identifier(
    code: str, error: CompilerError, lean_names: list[str]
) -> str | None:
    m = re.search(r"unknown identifier '([^']+)'", error.message)
    if not m:
        m = re.search(r"unknown constant '([^']+)'", error.message)
    if not m:
        return None

    bad_name = m.group(1)
    short_name = bad_name.rsplit(".", 1)[-1] if "." in bad_name else bad_name

    # Build short-name lookup for qualified names
    short_to_full: dict[str, str] = {}
    short_names: list[str] = []
    for name in lean_names:
        sn = name.rsplit(".", 1)[-1] if "." in name else name
        short_names.append(sn)
        short_to_full[sn] = name

    matches = difflib.get_close_matches(short_name, short_names, n=1, cutoff=0.8)
    if not matches:
        return None

    best_short = matches[0]
    # Use the full qualified name from the index
    replacement = short_to_full[best_short]

    return code.replace(bad_name, replacement)


# ---------------------------------------------------------------------------
# Tier B helpers
# ---------------------------------------------------------------------------

def _fix_type_coercion(code: str, error: CompilerError) -> str | None:
    msg = error.message
    if "type mismatch" not in msg.lower():
        return None

    for pattern, cast in TYPE_CAST_FIXES:
        if re.search(pattern, msg, re.DOTALL):
            if error.line and cast == "↑":
                lines = code.splitlines()
                if 0 < error.line <= len(lines):
                    line = lines[error.line - 1]
                    KEYWORDS = {
                        "def", "theorem", "lemma", "variable", "structure",
                        "class", "instance", "example", "if", "then", "else",
                        "let", "have", "from", "by", "calc", "where", "with",
                        "match", "fun", "Prop", "Type", "Sort", "import",
                        "open", "namespace", "section", "end",
                    }
                    pattern_re = re.compile(r"(?<![↑α-ωΑ-Ω])(\b[a-z_]\w*\b)")
                    for m in pattern_re.finditer(line):
                        word = m.group(1)
                        if word not in KEYWORDS:
                            start, end = m.span(1)
                            fixed = line[:start] + f"↑{word}" + line[end:]
                            lines[error.line - 1] = fixed
                            return "\n".join(lines)
            elif cast == ".toNat" and error.line:
                lines = code.splitlines()
                if 0 < error.line <= len(lines):
                    line = lines[error.line - 1]
                    fixed = re.sub(
                        r"(\b[a-z_]\w*\b)(?!\.toNat)", r"\1.toNat", line, count=1
                    )
                    if fixed != line:
                        lines[error.line - 1] = fixed
                        return "\n".join(lines)
    return None


def _fix_namespace_rename(code: str, error: CompilerError) -> str | None:
    m = re.search(
        r"unknown (?:constant|identifier|namespace) '([^']+)'", error.message
    )
    if not m:
        return None

    old_name = m.group(1)
    new_name = NAMESPACE_RENAMES.get(old_name)
    if new_name and new_name != old_name:
        return code.replace(old_name, new_name)

    return None


# ---------------------------------------------------------------------------
# Main repair interface
# ---------------------------------------------------------------------------

class RepairDB:
    """Three-tier deterministic repair engine.

    Attempts to fix compiler errors without LLM calls.
    Returns fixed code or None (signaling Tier C / LLM fallback).
    """

    def __init__(self, lean_names: list[str] | None = None):
        self._lean_names = lean_names or []

    def try_repair(
        self, code: str, errors: list[CompilerError]
    ) -> tuple[str | None, list[str]]:
        """Try deterministic repair.

        Returns (fixed_code, fix_descriptions) or (None, []).
        """
        current_code = code
        fixes_applied: list[str] = []

        for error in errors:
            fix = self._tier_a(current_code, error)
            if fix:
                current_code = fix
                fixes_applied.append(
                    f"Tier A: {error.category.value} — pattern fix"
                )
                continue

            fix = self._tier_b(current_code, error)
            if fix:
                current_code = fix
                fixes_applied.append(
                    f"Tier B: {error.category.value} — heuristic fix"
                )
                continue

        if fixes_applied and current_code != code:
            return current_code, fixes_applied

        return None, fixes_applied

    def _tier_a(self, code: str, error: CompilerError) -> str | None:
        fix = _fix_missing_tactic_import(code, error)
        if fix:
            return fix

        fix = _fix_prop_bool(code, error)
        if fix:
            return fix

        fix = _fix_trivial_goal(code, error)
        if fix:
            return fix

        if self._lean_names:
            fix = _fix_unknown_identifier(code, error, self._lean_names)
            if fix:
                return fix

        return None

    def _tier_b(self, code: str, error: CompilerError) -> str | None:
        fix = _fix_type_coercion(code, error)
        if fix:
            return fix

        fix = _fix_namespace_rename(code, error)
        if fix:
            return fix

        return None
