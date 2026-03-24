"""Deterministic pre-compiler — validates and fixes Lean code before compilation.

Runs after LLM generates code, before sending to the Lean compiler. Catches
cheap-to-fix errors that would otherwise waste a compiler round-trip AND an
LLM retry attempt.

Key fixes:
  - Lean 3→4 syntax repairs (∑/∏ binder `in` → `∈`, #check removal, etc.)
  - Validate identifiers against Mathlib index → replace hallucinated names
  - Ensure `import Mathlib` is present
  - Fix deprecated patterns (ExistsUnique, old API names)
  - Add missing `open scoped` for notation characters
  - Known namespace renames

Design principle: fixes here don't count as an attempt. The pre-compiler
silently improves code before it reaches the compiler. If the fixed code
still fails, the compiler error feeds back to the LLM at the *same* tier
level — no escalation penalty for fixable syntax issues.
"""

import difflib
import re

from ..mathlib_index import MathlibIndex


# ---------------------------------------------------------------------------
# Deprecated patterns
# ---------------------------------------------------------------------------

# ExistsUnique was deprecated — LLMs still generate the notation form
DEPRECATED_PATTERNS: list[tuple[re.Pattern, str, str]] = [
    # ExistsUnique notation → ∃!
    (re.compile(r'\bExistsUnique\b'), '∃!', 'ExistsUnique → ∃!'),
]

# Known Mathlib API renames (old → new)
API_RENAMES: dict[str, str] = {
    "Int.ediv_add_emod": "Int.mdiv_add_mmod",
    "Finset.sum_comm": "Finset.sum_comm'",
    "MeasureTheory.Measure.ae": "MeasureTheory.ae",
    "Nat.Prime.eq_one_or_self_of_dvd": "Nat.Prime.eq_one_or_self_of_dvd",
    # Hallucinated monotonicity identifiers — models invent these in Function/Order
    # namespaces but they don't exist. The correct forms are StrictMono.*/StrictAnti.*.
    "Function.lt_iff_lt": "StrictMono.lt_iff_lt",
    "Function.neg_strictAnti": "StrictMono.neg",          # doesn't exist; best approx
    "Function.lt_of_lt_map_lt": "StrictAnti.lt_iff_gt",
    "Function.gt_implies_lt": "StrictAnti.lt_iff_gt",
    "Function.neg_strictMono": "StrictAnti.neg",           # doesn't exist; best approx
    "Function.strictAnti_neg": "StrictAnti.lt_iff_gt",
    # Convexity — IsConvex is not a function, use Convex
    "IsConvex": "Convex ℝ",
    # Deprecated typeclass renames
    "Irreflexive": "Std.Irrefl",
    # Integration namespace — models hallucinate these
    "intervalIntegral.integral": "intervalIntegral",
    "MeasureTheory.IntervalIntegral.integral": "MeasureTheory.intervalIntegral",
    "MeasureTheory.intervalIntegral.integral": "MeasureTheory.intervalIntegral",
}

# Hallucinated / obsolete typeclass names → decomposed binder replacements.
#
# Mathlib4 unbundled many ordered algebraic classes. The old one-word classes
# (OrderedSemiring, OrderedRing, etc.) no longer exist. The new `Is*` types
# are Prop-valued and REQUIRE prerequisite instances — they can't be used
# alone in `[...]` binders without those prerequisites.
#
# When the LLM writes `[OrderedSemiring 𝕜]` or `[IsOrderedSemiring 𝕜]`,
# the pre-compiler expands the binder into the correct prerequisite chain.
#
# Format:  old_name → list of replacement binder class names.
# The type variable from the original binder is reused for each replacement.
# Example: `[OrderedRing R]` → `[Semiring R] [PartialOrder R] [IsOrderedRing R]`
CLASS_DECOMPOSITIONS: dict[str, list[str]] = {
    # OrderedSemiring / IsOrderedSemiring → neither exists; use components
    "OrderedSemiring":            ["Semiring", "PartialOrder"],
    "IsOrderedSemiring":          ["Semiring", "PartialOrder"],
    # OrderedRing → Is* exists as Prop, needs prerequisites
    "OrderedRing":                ["Semiring", "PartialOrder", "IsOrderedRing"],
    "IsOrderedRing":              ["Semiring", "PartialOrder", "IsOrderedRing"],
    # StrictOrderedRing → Is* exists as Prop, needs prerequisites
    "StrictOrderedRing":          ["Semiring", "PartialOrder", "IsStrictOrderedRing"],
    "IsStrictOrderedRing":        ["Semiring", "PartialOrder", "IsStrictOrderedRing"],
    # Ordered monoids
    "OrderedCommMonoid":          ["CommMonoid", "PartialOrder", "IsOrderedMonoid"],
    "OrderedAddCommMonoid":       ["AddCommMonoid", "PartialOrder", "IsOrderedAddMonoid"],
    # Ordered cancel monoids
    "OrderedCancelCommMonoid":    ["CommMonoid", "PartialOrder", "IsOrderedCancelMonoid"],
    "OrderedCancelAddCommMonoid": ["AddCommMonoid", "PartialOrder", "IsOrderedCancelAddMonoid"],
    # LinearOrderedCommGroupWithZero is still a real class — just rename
    "OrderedCommGroup":           ["LinearOrderedCommGroupWithZero"],
}

# Regex to match these names inside instance binders: [Name var] or [inst : Name var]
# Captures: (prefix)[ClassName (typevar)]  so we can expand.
_CLASS_DECOMP_RE = re.compile(
    r'\[(?:\w+\s*:\s*)?('
    + '|'.join(re.escape(k) for k in CLASS_DECOMPOSITIONS)
    + r')\s+(\S+)\]'
)

# Mathlib modules that were split into submodules.
# LLMs generate `import Mathlib.X` but the olean is now at `Mathlib.X.Basic` etc.
# The compiler error is: "object file ... of module Mathlib.X does not exist"
MODULE_RENAMES: dict[str, str] = {
    "Mathlib.Algebra.Group.Commute": "Mathlib.Algebra.Group.Commute.Defs",
    "Mathlib.Data.Nat.Digits": "Mathlib.Data.Nat.Digits.Defs",
    "Mathlib.Data.PNat": "Mathlib.Data.PNat.Defs",
    "Mathlib.NumberTheory.ArithmeticFunction":
        "Mathlib.NumberTheory.ArithmeticFunction.Defs",
}

# ---------------------------------------------------------------------------
# Lean 3→4 syntax patterns
# ---------------------------------------------------------------------------

# Big-operator binder: ∑ x in S, ... → ∑ x ∈ S, ...
# Must not match `∈` that's already correct.  The `in` keyword in big operator
# binders is Lean 3 syntax; Lean 4 Mathlib uses `∈`.
# Pattern explanation:
#   ([∑∏]\s+\w+\s+)  — capture ∑/∏ followed by a binder variable
#   in                — the Lean 3 keyword (must be a whole word)
#   (\s+)             — whitespace after `in`
# Replacement: \1∈\2  — swap `in` for `∈`
_BIG_OP_BINDER_IN_RE = re.compile(
    r'([∑∏]\s+\w+\s+)'   # ∑/∏ + variable + space
    r'\bin\b'              # the word "in"
    r'(\s+)'               # trailing space before the set expression
)

# Lines that are pure #check / #eval / #print / #reduce commands.
# These are debug commands that should never appear in proof code.
_HASH_CMD_LINE_RE = re.compile(
    r'^\s*#(?:check|eval|print|reduce)\b.*$', re.MULTILINE
)

# `by { tac1, tac2, ... }` → `by\n  tac1\n  tac2\n  ...`
# Only handles simple cases: no nested braces inside the block.
_BY_BRACE_RE = re.compile(
    r'\bby\s*\{\s*'        # `by {` with optional whitespace
    r'([^{}]+?)'           # tactic body — no nested braces
    r'\s*\}'               # closing `}`
)

# Notation characters that need `open scoped` to work
SCOPED_NOTATION: list[tuple[str, str]] = [
    ("\u2206", "open scoped symmDiff"),  # ∆ (INCREMENT)
    ("\u0394", "open scoped symmDiff"),  # Δ (GREEK CAPITAL DELTA)
]

# Identifiers that live in a namespace — if code uses them without the namespace
# prefix AND doesn't have the `open`, inject `open Namespace` automatically.
# Each entry: (identifier_pattern, required_open, already_open_check)
NAMESPACE_OPENS: list[tuple[re.Pattern, str]] = [
    # Filter.Tendsto — models write bare `Tendsto` or `Filter.Tendsto`
    (re.compile(r'(?<!\w)Tendsto\b'), "open Filter"),
    # nhds — models write bare `nhds` (word) or `𝓝` (unicode) without open Topology
    (re.compile(r'(?<!\w)nhds\b|𝓝'), "open Topology"),
    # BigOperators — ∑ and ∏ notation needs this
    (re.compile(r'[∑∏]'), "open BigOperators"),
    # Finset operations often need open Finset
    (re.compile(r'(?<!\w)Finset\.(?:sum|prod|card|filter|range|Icc|Ico)\b'), "open Finset"),
    # MeasureTheory — models often write `Measure`, `ae`, `Integrable` etc.
    (re.compile(r'(?<!\w)(?:MeasurableSet|Integrable|∫|MeasureTheory\.)\b'), "open MeasureTheory"),
    # Polynomial namespace
    (re.compile(r'(?<!\w)Polynomial\.(?:eval|degree|coeff|natDegree)\b'), "open Polynomial"),
    # FiniteDimensional — finrank and FiniteDimensional live here
    (re.compile(r'(?<!\w)(?:finrank|FiniteDimensional)\b'), "open FiniteDimensional"),
    # TFAE — List.TFAE is in the List namespace
    (re.compile(r'(?<!\w)TFAE\b'), "open List"),
    # ZMod namespace
    (re.compile(r'(?<!\w)ZMod\.(?:val|cast|card)\b'), "open ZMod"),
    # Matrix operations — det, transpose, etc.
    (re.compile(r'(?<!\w)Matrix\.(?:det|transpose|mul|trace|diagonal|of)\b'), "open Matrix"),
    # Probability theory — IndepSet, iIndepSet, etc.
    (re.compile(r'(?<!\w)(?:IndepSet|iIndepSet|IndepFun|iIndepFun|ProbabilityMeasure)\b'), "open ProbabilityTheory"),
    # Pmf — probability mass functions
    (re.compile(r'(?<!\w)Pmf\.'), "open MeasureTheory"),
]


# ---------------------------------------------------------------------------
# Pre-compiler
# ---------------------------------------------------------------------------

class PreCompiler:
    """Deterministic pre-compilation pass for Lean 4 code.

    Validates and fixes common LLM errors before sending to the Lean compiler.
    Returns (fixed_code, list_of_fixes_applied). If no fixes needed, returns
    the original code unchanged.

    Args:
        mathlib_index: Optional MathlibIndex for identifier validation.
            If provided, unknown identifiers are fuzzy-matched against real
            Mathlib declarations.
    """

    def __init__(self, mathlib_index: MathlibIndex | None = None):
        self._index = mathlib_index
        # Cache: short_name → full qualified name from index
        self._name_cache: dict[str, str] = {}

    def fix(self, code: str) -> tuple[str, list[str]]:
        """Apply all pre-compiler fixes to the code.

        Returns:
            (fixed_code, fixes_applied) where fixes_applied is a list of
            human-readable descriptions of what was changed. Empty list
            means no changes.
        """
        fixes: list[str] = []

        # Lean 3→4 syntax first — these cause cascading parse errors
        code, f = self._fix_lean3_syntax(code)
        fixes.extend(f)

        code, f = self._fix_module_renames(code)
        fixes.extend(f)

        code, f = self._fix_missing_import(code)
        fixes.extend(f)

        code, f = self._fix_scoped_notation(code)
        fixes.extend(f)

        code, f = self._fix_namespace_opens(code)
        fixes.extend(f)

        code, f = self._fix_deprecated(code)
        fixes.extend(f)

        code, f = self._fix_api_renames(code)
        fixes.extend(f)

        code, f = self._fix_class_renames(code)
        fixes.extend(f)

        if self._index and self._index.size > 0:
            code, f = self._fix_identifiers(code)
            fixes.extend(f)

        code, f = self._fix_linter_warnings(code)
        fixes.extend(f)

        code, f = self._fix_noncomputable(code)
        fixes.extend(f)

        return code, fixes

    # ------------------------------------------------------------------
    # Individual fixers
    # ------------------------------------------------------------------

    def _fix_lean3_syntax(self, code: str) -> tuple[str, list[str]]:
        """Fix Lean 3 syntax that LLMs produce instead of Lean 4.

        This is the single largest parse-error category (~28% of failures).
        Fixes are applied before all other passes because syntax errors cause
        cascading failures that mask the real issue.
        """
        fixes: list[str] = []

        # (a, b) Big-operator binder: ∑ x in S, → ∑ x ∈ S,  (same for ∏)
        if _BIG_OP_BINDER_IN_RE.search(code):
            code = _BIG_OP_BINDER_IN_RE.sub(r'\1∈\2', code)
            fixes.append("Lean3→4: big-operator binder `in` → `∈`")

        # (c, e) Remove #check / #eval / #print / #reduce lines
        if _HASH_CMD_LINE_RE.search(code):
            code = _HASH_CMD_LINE_RE.sub('', code)
            # Clean up blank lines left behind (collapse multiple blank lines)
            code = re.sub(r'\n{3,}', '\n\n', code)
            fixes.append("Lean3→4: removed #check/#eval/#print/#reduce lines")

        # (d) `by { tac1, tac2 }` → `by\n  tac1\n  tac2`
        if _BY_BRACE_RE.search(code):
            def _rewrite_by_brace(m: re.Match) -> str:
                body = m.group(1).strip()
                # Split on commas (Lean 3 tactic separator) or semicolons
                tactics = [t.strip() for t in re.split(r'[,;]', body) if t.strip()]
                return 'by\n' + '\n'.join('  ' + t for t in tactics)

            code = _BY_BRACE_RE.sub(_rewrite_by_brace, code)
            fixes.append("Lean3→4: `by { ... }` → `by` block")

        # (f) sorry cleanup: remove `sorry` lines when mixed with real tactics.
        # If sorry is the ONLY tactic in a `by` block, leave it (it's a placeholder).
        # If sorry appears alongside real tactics, the real tactics are the proof
        # and sorry is leftover scaffolding from the LLM.
        code, sorry_fixed = self._fix_mixed_sorry(code)
        if sorry_fixed:
            fixes.append("Lean3→4: removed stale `sorry` mixed with real tactics")

        return code, fixes

    @staticmethod
    def _fix_mixed_sorry(code: str) -> tuple[str, bool]:
        """Remove `sorry` lines that appear mixed with real tactics in `by` blocks.

        Leaves `sorry` alone when it's the sole tactic (the proof is genuinely
        incomplete / a placeholder).
        """
        lines = code.splitlines()
        result: list[str] = []
        fixed = False
        i = 0
        while i < len(lines):
            line = lines[i]
            # Detect start of a `by` block (line ends with `by` or is just `by`)
            stripped = line.rstrip()
            if stripped.endswith(' by') or stripped == 'by' or re.search(r':=\s*by\s*$', stripped):
                # Collect the tactic block (indented lines following `by`)
                result.append(line)
                i += 1
                block_start = i
                # Determine the base indent of the by-block
                base_indent = None
                tactic_lines: list[tuple[int, str]] = []  # (original index, line)
                while i < len(lines):
                    tline = lines[i]
                    tstripped = tline.strip()
                    if tstripped == '':
                        tactic_lines.append((i, tline))
                        i += 1
                        continue
                    indent = len(tline) - len(tline.lstrip())
                    if base_indent is None:
                        base_indent = indent
                    # If dedented back to or beyond `by` level, block is over
                    if indent < base_indent and tstripped != '':
                        break
                    tactic_lines.append((i, tline))
                    i += 1

                # Analyse: how many non-empty, non-sorry tactic lines?
                real_tactics = [
                    (idx, l) for idx, l in tactic_lines
                    if l.strip() and l.strip() != 'sorry'
                ]
                sorry_lines = [
                    (idx, l) for idx, l in tactic_lines
                    if l.strip() == 'sorry'
                ]

                if real_tactics and sorry_lines:
                    # Mixed: drop the sorry lines
                    fixed = True
                    for idx, l in tactic_lines:
                        if l.strip() != 'sorry':
                            result.append(l)
                else:
                    # All sorry or no sorry — keep as-is
                    for idx, l in tactic_lines:
                        result.append(l)
            else:
                result.append(line)
                i += 1

        return '\n'.join(result), fixed

    def _fix_module_renames(self, code: str) -> tuple[str, list[str]]:
        """Fix imports of Mathlib modules that were split into submodules."""
        fixes = []
        for old_mod, new_mod in MODULE_RENAMES.items():
            # Match exact import line (not a prefix of a longer module path)
            pattern = re.compile(r'^(import\s+)' + re.escape(old_mod) + r'\s*$',
                                 re.MULTILINE)
            if pattern.search(code):
                code = pattern.sub(r'\g<1>' + new_mod, code)
                fixes.append(f"Module: {old_mod} → {new_mod}")
        return code, fixes

    # Lines that are Mathlib infrastructure (imports + opens) — safe to strip
    # when the theorem body doesn't actually use any Mathlib content.
    _MATHLIB_INFRA_LINE: re.Pattern = re.compile(
        r'^\s*import\s+Mathlib'  # import Mathlib or import Mathlib.X.Y.Z
        r'|^\s*open\s+(?:scoped\s+)?'
        r'(?:BigOperators|Finset|Topology|Filter|MeasureTheory'
        r'|Polynomial|Matrix|ProbabilityTheory|Set|NNReal|ENNReal'
        r'|Cardinal|Ordinal|ContinuousMap)\b'
    )

    # Unicode math type symbols and big-operator notation that require Mathlib.
    # Pure Lean 4 prelude files won't contain these.
    _MATHLIB_INDICATORS: re.Pattern = re.compile(
        r'[ℕℤℝℚℂℍ𝕜∑∏∫𝓝𝓤𝓟∆\u0394]'                  # math unicode (incl. symmDiff ∆/Δ)
        r'|(?<!\w)(?:Finset|Real|Complex|Polynomial'  # Mathlib-specific namespaces
        r'|MeasureTheory|Topology|Filter|Metric'
        r'|NumberTheory|GroupTheory|LinearAlgebra'
        r'|RingTheory|FieldTheory|CategoryTheory'
        r'|Analysis|Algebra|Combinatorics)\.'
        r'|open\s+(?:BigOperators|Finset|Topology|Filter|MeasureTheory'
        r'|Polynomial|Matrix|ProbabilityTheory)'
        r'|(?<!\w)Nat\.(?:Prime|Coprime|factorial|choose|gcd|lcm|sqrt'
        r'|succ_pos|zero_lt_succ|dvd_antisymm|cast)'  # Mathlib Nat lemmas (not prelude)
        r'|(?<!\w)Int\.(?:coe_nat|ofNat|cast|ediv|emod|natAbs)'
        # Mathlib tactics (not available in the bare Lean 4 prelude)
        r'|(?<!\w)(?:norm_num|linarith|ring|field_simp|positivity|gcongr'
        r'|push_cast|norm_cast|polyrith|simp_arith|aesop|omega_nat)\b'
        # Bare Mathlib identifiers visible after opens (Filter, Topology, etc.)
        r'|(?<!\w)(?:Tendsto|atTop|atBot|Eventually|Frequently'
        r'|nhds|nhdsWithin|IsOpen|IsClosed|IsCompact|Continuous'
        r'|Measurable|MeasurableSet|Integrable|finrank)\b'
    )

    def _fix_missing_import(self, code: str) -> tuple[str, list[str]]:
        """Ensure `import Mathlib` is present (or stripped if unused).

        The umbrella `import Mathlib` imports everything. We:
        1. Add `import Mathlib` if missing — but ONLY when the code actually
           uses Mathlib-specific content (math unicode, known Mathlib namespaces).
           Pure propositional logic / prelude-only files are left without imports
           so they compile instantly without loading all of Mathlib.
        2. Strip `import Mathlib` and Mathlib-specific `open` statements when
           the theorem body doesn't use any Mathlib content — the LLM often adds
           these by default even for pure prelude code, causing 600s timeouts
           when the Mathlib .olean cache is cold.
        3. Strip all `import Mathlib.X.Y.Z` lines (they're covered by the umbrella)
        """
        fixes: list[str] = []
        lines = code.splitlines()

        # Check if the umbrella import exists (exact line, not a substring match)
        has_umbrella = any(
            re.match(r'^\s*import\s+Mathlib\s*$', line) for line in lines
        )

        if has_umbrella:
            # Check if the non-infrastructure code actually needs Mathlib.
            # If not, strip the import and Mathlib-specific opens so the code
            # routes to standalone mode (120s) instead of Lake (600s).
            core_lines = [l for l in lines if not self._MATHLIB_INFRA_LINE.match(l)]
            core_code = "\n".join(core_lines)
            if not self._MATHLIB_INDICATORS.search(core_code):
                lines = core_lines
                fixes.append("Stripped unused `import Mathlib` (pure prelude code — avoids 600s timeout)")
                has_umbrella = False  # allow injection path below if something was missed
        else:
            has_imports = any(line.strip().startswith("import ") for line in lines)
            # Only inject `import Mathlib` if the code actually references
            # Mathlib content.  Pure prelude files (Prop, And, Iff, fun, ⟨⟩)
            # compile instantly without the import; injecting it unconditionally
            # causes 600s timeouts when the Mathlib cache is cold.
            needs_mathlib = has_imports or self._MATHLIB_INDICATORS.search(code) is not None
            if needs_mathlib:
                # Find where to insert
                if has_imports:
                    last_import_idx = 0
                    for i, line in enumerate(lines):
                        if line.strip().startswith("import "):
                            last_import_idx = i
                    lines.insert(last_import_idx + 1, "import Mathlib")
                else:
                    lines.insert(0, "import Mathlib")
                fixes.append("Added missing `import Mathlib`")

        # Strip redundant specific Mathlib imports (import Mathlib.X.Y.Z)
        # since the umbrella import covers everything
        stripped = []
        removed = []
        for line in lines:
            if re.match(r'^\s*import\s+Mathlib\.\S+', line):
                removed.append(line.strip())
            else:
                stripped.append(line)

        if removed:
            lines = stripped
            fixes.append(f"Stripped {len(removed)} redundant Mathlib submodule import(s)")

        return "\n".join(lines), fixes

    def _fix_scoped_notation(self, code: str) -> tuple[str, list[str]]:
        """Add `open scoped` for notation characters that need it."""
        fixes = []
        for char, open_stmt in SCOPED_NOTATION:
            if char in code and open_stmt not in code:
                code = _add_open_scoped(code, open_stmt)
                fixes.append(f"Added `{open_stmt}` for notation char")
        return code, fixes

    def _fix_namespace_opens(self, code: str) -> tuple[str, list[str]]:
        """Add `open Namespace` when code uses identifiers that need it.

        LLMs frequently use `Tendsto`, `𝓝`, `∑` etc. without opening the
        containing namespace, causing 'Function expected' or 'unknown identifier'.
        """
        fixes = []
        for pattern, open_stmt in NAMESPACE_OPENS:
            if pattern.search(code) and open_stmt not in code:
                code = _add_open_scoped(code, open_stmt)
                fixes.append(f"Added `{open_stmt}` for namespaced identifiers")
        return code, fixes

    def _fix_deprecated(self, code: str) -> tuple[str, list[str]]:
        """Fix deprecated patterns."""
        fixes = []
        for pattern, replacement, description in DEPRECATED_PATTERNS:
            if pattern.search(code):
                code = pattern.sub(replacement, code)
                fixes.append(f"Deprecated: {description}")
        return code, fixes

    def _fix_api_renames(self, code: str) -> tuple[str, list[str]]:
        """Fix known API renames."""
        fixes = []
        for old_name, new_name in API_RENAMES.items():
            if old_name in code and old_name != new_name:
                code = code.replace(old_name, new_name)
                fixes.append(f"Rename: {old_name} → {new_name}")
        return code, fixes

    def _fix_class_renames(self, code: str) -> tuple[str, list[str]]:
        """Fix hallucinated / obsolete typeclass names in instance binders.

        Mathlib4 unbundled ordered algebraic classes. Old names like
        `OrderedSemiring` and `IsOrderedSemiring` no longer work as instance
        binders. This expands `[OldName var]` into the correct prerequisite
        chain, e.g. `[Semiring var] [PartialOrder var]`.

        Avoids duplicate binders: if the code already has `[Semiring 𝕜]`,
        we won't add another one.
        """
        fixes = []

        def _expand_binder(m: re.Match) -> str:
            old_class = m.group(1)
            type_var = m.group(2)
            replacements = CLASS_DECOMPOSITIONS.get(old_class)
            if not replacements:
                return m.group(0)  # no-op

            # Build replacement binders.  Skip prerequisites that already
            # appear elsewhere in the code (outside this match), but always
            # include all binders from the decomposition list.
            original = m.group(0)  # the matched binder being replaced
            # Code with this match removed — for checking what's already present
            rest = code[:m.start()] + code[m.end():]

            new_binders = []
            for cls in replacements:
                binder = f"[{cls} {type_var}]"
                if binder not in rest:
                    new_binders.append(binder)
            if not new_binders:
                return m.group(0)  # all already present elsewhere

            fixes.append(
                f"Class decompose: [{old_class} {type_var}] → "
                + " ".join(new_binders)
            )
            return " ".join(new_binders)

        code = _CLASS_DECOMP_RE.sub(_expand_binder, code)
        return code, fixes

    def _fix_identifiers(self, code: str) -> tuple[str, list[str]]:
        """Validate identifiers against Mathlib index, replace hallucinated ones.

        Finds qualified names (Foo.bar_baz) in the code that look like Mathlib
        references, checks if they exist in the index, and replaces with the
        closest match if not.
        """
        fixes = []

        # Find qualified identifiers (Namespace.name patterns)
        # Must have at least one dot to be a qualified Mathlib reference
        qualified_pattern = re.compile(
            r'(?<![`\w])([A-Z]\w+(?:\.[a-zA-Z_]\w*)+)(?![`\w])'
        )

        matches = list(qualified_pattern.finditer(code))
        if not matches:
            return code, fixes

        # Deduplicate
        seen: set[str] = set()
        replacements: dict[str, str] = {}

        for m in matches:
            name = m.group(1)
            if name in seen:
                continue
            seen.add(name)

            # Skip common non-Mathlib patterns
            if name.startswith(("Lean.", "IO.", "System.", "String.", "Array.",
                                "List.", "Option.", "Decidable.")):
                continue

            # Check if it exists in the index
            if self._lookup_exact(name):
                continue

            # Try to find a close match
            replacement = self._find_closest(name)
            if replacement and replacement != name:
                replacements[name] = replacement

        # Apply replacements
        for old_name, new_name in replacements.items():
            code = code.replace(old_name, new_name)
            fixes.append(f"Identifier: {old_name} → {new_name}")

        return code, fixes

    @staticmethod
    def _fix_linter_warnings(code: str) -> tuple[str, list[str]]:
        """Suppress unused variable linter warnings that cause false failures.

        Lean 4 treats unused variable warnings as errors in some contexts.
        Adding `set_option linter.unusedVariables false` prevents these from
        blocking compilation of otherwise correct proofs.
        """
        if "set_option linter.unusedVariables" in code:
            return code, []
        # Check if code uses patterns prone to unused variable warnings
        # (lambda binders, match arms, let bindings with underscores)
        if any(kw in code for kw in ["fun ", "match ", "let ", "have "]):
            lines = code.splitlines()
            insert_idx = 0
            for i, line in enumerate(lines):
                stripped = line.strip()
                if stripped.startswith("import ") or stripped.startswith("open ") or stripped.startswith("set_option"):
                    insert_idx = i + 1
            lines.insert(insert_idx, "set_option linter.unusedVariables false")
            return "\n".join(lines), ["Suppressed unused variable linter"]
        return code, []

    @staticmethod
    def _fix_noncomputable(code: str) -> tuple[str, list[str]]:
        """Add `noncomputable` to definitions that use Real or other noncomputable types.

        When a definition depends on `Real.*` operations (division, sqrt, etc.),
        Lean requires it to be marked `noncomputable`. The model often forgets this.
        """
        if "noncomputable" in code:
            return code, []
        # Check if code uses Real-dependent operations without noncomputable
        real_patterns = ["Real.", ": ℝ", "→ ℝ", "(ℝ)", "Float", "NNReal"]
        uses_real = any(p in code for p in real_patterns)
        has_def = re.search(r'^(def |abbrev |instance )', code, re.MULTILINE)
        if uses_real and has_def:
            code = re.sub(
                r'^(def |abbrev |instance )',
                r'noncomputable \1',
                code,
                count=0,
                flags=re.MULTILINE,
            )
            return code, ["Added `noncomputable` for Real-dependent definitions"]
        return code, []

    def _lookup_exact(self, name: str) -> bool:
        """Check if an identifier exists exactly in the index.

        Uses MathlibIndex.has_name() for O(1) set lookup instead of
        running a full TF-IDF/embedding search just to check existence.
        """
        if not self._index:
            return True  # no index → assume it exists

        # Check cache
        if name in self._name_cache:
            return True

        # O(1) set lookup via has_name
        if self._index.has_name(name):
            self._name_cache[name] = name
            return True

        return False

    def _find_closest(self, name: str) -> str | None:
        """Find the closest Mathlib identifier to a hallucinated one."""
        if not self._index:
            return None

        # Check cache
        if name in self._name_cache:
            return self._name_cache[name]

        # Search by the full qualified name
        results = self._index.search(name, top_k=5)
        if not results:
            return None

        # Extract the short name (last component) for fuzzy matching
        short_name = name.rsplit(".", 1)[-1] if "." in name else name
        # Also extract the namespace prefix
        namespace = name.rsplit(".", 1)[0] if "." in name else ""

        best_match = None
        best_score = 0.0

        for result in results:
            result_short = result.name.rsplit(".", 1)[-1] if "." in result.name else result.name
            result_ns = result.name.rsplit(".", 1)[0] if "." in result.name else ""

            # Fuzzy match on the short name
            ratio = difflib.SequenceMatcher(None, short_name.lower(), result_short.lower()).ratio()

            # Bonus for matching namespace
            if namespace and result_ns and namespace.lower() == result_ns.lower():
                ratio += 0.2

            if ratio > best_score:
                best_score = ratio
                best_match = result.name

        # Only replace if the match is close enough (>0.7)
        if best_match and best_score >= 0.7:
            self._name_cache[name] = best_match
            return best_match

        return None


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _add_open_scoped(code: str, open_stmt: str) -> str:
    """Insert an `open scoped` statement after imports / before first declaration."""
    lines = code.splitlines()
    insert_idx = 0
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("import ") or stripped.startswith("open "):
            insert_idx = i + 1
    lines.insert(insert_idx, open_stmt)
    return "\n".join(lines)
