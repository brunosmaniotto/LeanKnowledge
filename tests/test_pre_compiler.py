"""Tests for the deterministic pre-compiler."""

import re

from leanknowledge.lean.pre_compiler import PreCompiler


def test_adds_missing_import_mathlib():
    # Code with a Mathlib indicator (ℕ) should always get the import injected
    code = "theorem foo (n : ℕ) : n + 0 = n := by omega"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "import Mathlib" in fixed
    assert any("import Mathlib" in f for f in fixes)


def test_no_import_for_prelude_only():
    # Pure Lean 4 prelude code (Prop, True, trivial) must NOT get import Mathlib
    # injected — importing it triggers a 600s cold-cache timeout for no benefit.
    code = "theorem foo : True := trivial"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "import Mathlib" not in fixed
    assert not any("import Mathlib" in f for f in fixes)


def test_no_duplicate_import():
    # Code that actually uses Mathlib (norm_num) must not get a duplicate import
    code = "import Mathlib\n\ntheorem foo : (1 : ℕ) + 1 = 2 := by norm_num"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert fixed.count("import Mathlib") == 1
    assert not any("import Mathlib" in f for f in fixes)


def test_import_added_after_existing_imports():
    code = "import Init\nimport Lean\n\ntheorem foo : True := trivial"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    lines = fixed.splitlines()
    mathlib_idx = next(i for i, l in enumerate(lines) if l == "import Mathlib")
    lean_idx = next(i for i, l in enumerate(lines) if l == "import Lean")
    assert mathlib_idx > lean_idx


def test_scoped_notation_delta_increment():
    code = "import Mathlib\n\ntheorem foo (A B : Set Nat) : A \u2206 B = B \u2206 A := by\n  exact symmDiff_comm A B"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "open scoped symmDiff" in fixed
    assert any("notation" in f for f in fixes)


def test_scoped_notation_delta_greek():
    code = "import Mathlib\n\ntheorem foo (A B : Set Nat) : A \u0394 B = B \u0394 A := by\n  exact symmDiff_comm A B"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "open scoped symmDiff" in fixed


def test_scoped_notation_not_duplicated():
    code = "import Mathlib\nopen scoped symmDiff\n\ntheorem foo (A B : Set Nat) : A \u2206 B = B \u2206 A := by\n  exact symmDiff_comm A B"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert fixed.count("open scoped symmDiff") == 1
    assert not any("notation" in f for f in fixes)


def test_deprecated_exists_unique():
    code = "import Mathlib\n\ntheorem foo : ExistsUnique (fun x => x = 0) := by sorry"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "ExistsUnique" not in fixed
    assert "\u2203!" in fixed  # ∃!
    assert any("Deprecated" in f for f in fixes)


def test_api_rename():
    code = "import Mathlib\n\nexample : True := by\n  have h := Int.ediv_add_emod 5 3\n  trivial"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "Int.ediv_add_emod" not in fixed
    assert "Int.mdiv_add_mmod" in fixed
    assert any("Rename" in f for f in fixes)


def test_no_fixes_needed():
    code = "import Mathlib\n\ntheorem foo : 1 + 1 = 2 := by norm_num"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert fixed == code
    assert fixes == []


def test_multiple_fixes_combined():
    code = "theorem foo (A B : Set Nat) : A \u2206 B = B \u2206 A := by\n  exact symmDiff_comm A B"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "import Mathlib" in fixed
    assert "open scoped symmDiff" in fixed
    assert len(fixes) == 2


def test_open_scoped_after_imports():
    code = "import Mathlib\nimport Init\n\ntheorem foo (A B : Set Nat) : A \u2206 B = B \u2206 A := by sorry"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    lines = fixed.splitlines()
    scoped_idx = next(i for i, l in enumerate(lines) if "open scoped" in l)
    last_import_idx = max(i for i, l in enumerate(lines) if l.strip().startswith("import "))
    assert scoped_idx > last_import_idx


def test_class_rename_ordered_ring():
    code = "import Mathlib\n\nvariable {R : Type*} [OrderedRing R]\n\ntheorem foo (x : R) : 0 \u2264 x * x := by positivity"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert not re.search(r'(?<!Is)OrderedRing\b', fixed)
    assert "IsOrderedRing" in fixed
    assert any("Class" in f for f in fixes)


def test_class_rename_in_theorem_binder():
    code = "import Mathlib\n\ntheorem foo {G : Type*} [OrderedCommGroup G] (x y : G) : x < y := by sorry"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert not re.search(r'\bOrderedCommGroup\b', fixed)
    assert any("Class" in f for f in fixes)


def test_class_decompose_strict_ordered_ring():
    """StrictOrderedRing decomposes into Semiring + PartialOrder + IsStrictOrderedRing."""
    code = "import Mathlib\n\nvariable (R : Type) [StrictOrderedRing R]"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "StrictOrderedRing" not in fixed or "IsStrictOrderedRing" in fixed
    assert "[Semiring R]" in fixed
    assert "[PartialOrder R]" in fixed
    assert "[IsStrictOrderedRing R]" in fixed


def test_class_decompose_no_duplicate_binders():
    """IsOrderedRing already in code — decomposes, adding prerequisites."""
    code = "import Mathlib\n\nvariable {R : Type*} [IsOrderedRing R]"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    # IsOrderedRing should still be present (part of decomposition)
    assert fixed.count("IsOrderedRing") == 1
    # Prerequisites should be added
    assert "[Semiring R]" in fixed
    assert "[PartialOrder R]" in fixed


def test_class_decompose_skip_existing_prereqs():
    """Don't duplicate binders that already exist elsewhere in the code."""
    code = "import Mathlib\n\nvariable {R : Type*} [Semiring R] [OrderedRing R]"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    # Should not add a second [Semiring R]
    assert fixed.count("[Semiring R]") == 1
    assert "[PartialOrder R]" in fixed
    assert "[IsOrderedRing R]" in fixed


def test_class_decompose_ordered_semiring():
    """OrderedSemiring (doesn't exist) decomposes to Semiring + PartialOrder."""
    code = "import Mathlib\n\nvariable {S : Type*} [OrderedSemiring S]"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "OrderedSemiring" not in fixed
    assert "[Semiring S]" in fixed
    assert "[PartialOrder S]" in fixed


def test_class_decompose_ordered_comm_monoid():
    code = "import Mathlib\n\nvariable {S : Type*} [OrderedCommMonoid S]"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "OrderedCommMonoid" not in fixed
    assert "[CommMonoid S]" in fixed
    assert "[PartialOrder S]" in fixed
    assert "[IsOrderedMonoid S]" in fixed


def test_submodule_import_replaced_by_umbrella():
    """Specific Mathlib submodule imports get replaced by `import Mathlib`."""
    code = "import Mathlib.GroupTheory.Subgroup.Basic\n\ntheorem foo : True := trivial"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "import Mathlib\n" in fixed
    assert "Mathlib.GroupTheory.Subgroup.Basic" not in fixed
    assert any("Stripped" in f for f in fixes)


def test_multiple_submodule_imports_stripped():
    """Multiple specific imports all get stripped and replaced by umbrella."""
    code = "import Mathlib.Data.Nat.Digits\nimport Mathlib.GroupTheory.Cyclic\n\nexample : True := trivial"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "import Mathlib\n" in fixed
    assert "Mathlib.Data.Nat.Digits" not in fixed
    assert "Mathlib.GroupTheory.Cyclic" not in fixed


def test_umbrella_plus_submodule_strips_submodule():
    """When umbrella import already present, specific imports still stripped."""
    # Use code that needs Mathlib (ℕ), so umbrella is kept and only submodule stripped
    code = "import Mathlib\nimport Mathlib.Data.Nat.Digits\n\ntheorem foo (n : ℕ) : n + 0 = n := by omega"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert fixed.count("import Mathlib") == 1
    assert "Mathlib.Data.Nat.Digits" not in fixed


def test_non_mathlib_imports_preserved():
    """Non-Mathlib imports (import Init, import Lean) are not stripped."""
    code = "import Init\nimport Lean\n\ntheorem foo : True := trivial"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "import Init" in fixed
    assert "import Lean" in fixed
    assert "import Mathlib" in fixed


def test_only_submodule_import_gets_umbrella():
    """Code with only `import Mathlib.X.Y` — the main failure case from Run 7.

    The LLM generates a specific import for a module that was split/moved.
    Pre-compiler should add umbrella and strip the broken specific import.
    """
    code = "import Mathlib.LinearAlgebra.Basis\n\ntheorem foo : True := trivial"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "import Mathlib\n" in fixed
    assert "Mathlib.LinearAlgebra.Basis" not in fixed
    assert any("import Mathlib" in f for f in fixes)
    assert any("Stripped" in f for f in fixes)


# ---------------------------------------------------------------------------
# Namespace open injection tests
# ---------------------------------------------------------------------------


def test_open_filter_for_tendsto():
    code = "import Mathlib\n\ntheorem foo : Tendsto f atTop (nhds 0) := by sorry"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "open Filter" in fixed
    assert any("namespace" in f.lower() for f in fixes)


def test_open_big_operators_for_sum():
    code = "import Mathlib\n\ntheorem foo : \u2211 i in Finset.range 10, i = 45 := by sorry"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert "open BigOperators" in fixed


def test_open_not_duplicated():
    # open Filter already present — must not be added again; nhds legitimately needs open Topology
    code = "import Mathlib\nopen Filter\n\ntheorem foo : Tendsto f atTop (nhds 0) := by sorry"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    assert fixed.count("open Filter") == 1  # not duplicated
    assert not any("open Filter" in f for f in fixes)  # no spurious Filter namespace fix


def test_open_topology_for_nhds():
    code = "import Mathlib\n\ntheorem foo (x : \u211d) : \U0001d4dd x = \U0001d4dd x := by rfl"
    pc = PreCompiler()
    fixed, fixes = pc.fix(code)
    # 𝓝 should trigger open Topology
    assert "open Topology" in fixed or "open Filter" in fixed


# ---------------------------------------------------------------------------
# Lean 3→4 syntax repair tests
# ---------------------------------------------------------------------------


class TestSumBinder:
    """∑ x in S, → ∑ x ∈ S,"""

    def test_sum_in_to_mem(self):
        code = "import Mathlib\n\nexample : ∑ i in Finset.range 10, i = 45 := by sorry"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "∑ i ∈ Finset.range 10," in fixed
        assert "∑ i in " not in fixed
        assert any("big-operator" in f for f in fixes)

    def test_sum_multiword_expr(self):
        """Handles complex set expressions after `in`."""
        code = "import Mathlib\n\nexample : ∑ k in Finset.range (n + 1), k = 0 := by sorry"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "∑ k ∈ Finset.range (n + 1)," in fixed

    def test_sum_already_correct(self):
        """Code with ∈ already should not be changed."""
        code = "import Mathlib\n\nexample : ∑ i ∈ Finset.range 10, i = 45 := by sorry"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "∑ i ∈ Finset.range 10," in fixed
        assert not any("big-operator" in f for f in fixes)

    def test_prod_in_to_mem(self):
        """∏ binder uses same rule."""
        code = "import Mathlib\n\nexample : ∏ i in Finset.range 5, i = 0 := by sorry"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "∏ i ∈ Finset.range 5," in fixed
        assert "∏ i in " not in fixed

    def test_mixed_correct_and_incorrect(self):
        """Only fixes the incorrect one."""
        code = (
            "import Mathlib\n\n"
            "example : ∑ i ∈ Finset.range 5, i +\n"
            "  ∑ j in Finset.range 3, j = 0 := by sorry"
        )
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        # The already-correct one stays correct
        assert "∑ i ∈ Finset.range 5," in fixed
        # The incorrect one gets fixed
        assert "∑ j ∈ Finset.range 3," in fixed
        assert "∑ j in " not in fixed

    def test_for_in_not_touched(self):
        """The word `in` in `for x in xs` should NOT be replaced."""
        code = "import Mathlib\n\n#eval for x in [1, 2, 3] do IO.println x"
        pc = PreCompiler()
        fixed, _ = pc.fix(code)
        # The `for x in` should not become `for x ∈`
        # (The #eval line will be removed, but the regex itself should not match `for x in`)
        # Let's test the regex directly:
        from leanknowledge.lean.pre_compiler import _BIG_OP_BINDER_IN_RE
        assert not _BIG_OP_BINDER_IN_RE.search("for x in [1, 2, 3] do IO.println x")

    def test_if_in_not_touched(self):
        """The word `in` in `if x in s then` should not be replaced."""
        from leanknowledge.lean.pre_compiler import _BIG_OP_BINDER_IN_RE
        assert not _BIG_OP_BINDER_IN_RE.search("if x in s then 1 else 0")


class TestHashCommandRemoval:
    """#check / #eval / #print / #reduce removal."""

    def test_remove_check(self):
        code = "import Mathlib\n\n#check Nat.add_comm\n\ntheorem foo : True := trivial"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "#check" not in fixed
        assert "theorem foo : True := trivial" in fixed
        assert any("#check" in f for f in fixes)

    def test_remove_eval(self):
        code = "import Mathlib\n\n#eval 1 + 1\n\ntheorem foo : True := trivial"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "#eval" not in fixed
        assert "theorem foo : True := trivial" in fixed

    def test_remove_print(self):
        code = "import Mathlib\n\n#print Nat\n\ntheorem foo : True := trivial"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "#print" not in fixed

    def test_remove_reduce(self):
        code = "import Mathlib\n\n#reduce 2 + 3\n\ntheorem foo : True := trivial"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "#reduce" not in fixed

    def test_multiple_hash_commands(self):
        code = "import Mathlib\n\n#check Nat\n#eval 42\n#print axioms\n\ntheorem foo : True := trivial"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "#check" not in fixed
        assert "#eval" not in fixed
        assert "#print" not in fixed
        assert "theorem foo : True := trivial" in fixed

    def test_no_hash_commands_no_fix(self):
        code = "import Mathlib\n\ntheorem foo : True := trivial"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert not any("#check" in f for f in fixes)


class TestByBraceSyntax:
    """by { tac1, tac2 } → by block."""

    def test_simple_by_brace(self):
        code = "import Mathlib\n\ntheorem foo : 1 = 1 := by { rfl }"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "{ rfl }" not in fixed
        assert "by\n  rfl" in fixed
        assert any("by {" in f or "by { ... }" in f for f in fixes)

    def test_multi_tactic_by_brace(self):
        code = "import Mathlib\n\ntheorem foo : True := by { trivial, done }"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "{" not in fixed.split("by", 1)[-1] or "by\n" in fixed
        assert "  trivial" in fixed
        assert "  done" in fixed

    def test_semicolon_separator(self):
        code = "import Mathlib\n\ntheorem foo : True := by { trivial; done }"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "  trivial" in fixed
        assert "  done" in fixed

    def test_nested_braces_outer_preserved(self):
        """Outer by-block with nested braces is left alone; only inner simple ones rewritten."""
        code = "import Mathlib\n\ntheorem foo : True := by { simp [show 1 = 1 from by { rfl }] }"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        # The [^{}] in the regex won't match across nested braces, so the
        # OUTER `by { simp [...] }` stays as-is. The INNER `by { rfl }` is
        # simple and gets rewritten to `by\n  rfl` — that's correct.
        assert "by { simp" in fixed  # outer block preserved


class TestSorryCleanup:
    """sorry removal when mixed with real tactics."""

    def test_sorry_only_kept(self):
        """A proof that's just `sorry` — leave it alone."""
        code = "import Mathlib\n\ntheorem foo : True := by\n  sorry"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "sorry" in fixed
        assert not any("sorry" in f for f in fixes)

    def test_sorry_mixed_with_real_tactics(self):
        """sorry alongside real tactics gets removed."""
        code = "import Mathlib\n\ntheorem foo : 1 + 1 = 2 := by\n  norm_num\n  sorry"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "sorry" not in fixed
        assert "norm_num" in fixed
        assert any("sorry" in f for f in fixes)

    def test_sorry_mixed_multiple_real(self):
        code = "import Mathlib\n\ntheorem foo : True := by\n  have h := trivial\n  sorry\n  exact h"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "sorry" not in fixed
        assert "have h := trivial" in fixed
        assert "exact h" in fixed


class TestLean3SyntaxNoFalsePositives:
    """Ensure valid Lean 4 code is not mangled."""

    def test_clean_lean4_unchanged(self):
        code = "import Mathlib\n\ntheorem foo : ∑ i ∈ Finset.range 10, i = 45 := by\n  norm_num"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        # Should have no Lean3→4 fixes (may have other fixes like open BigOperators)
        assert not any("Lean3→4" in f for f in fixes)
        assert "∑ i ∈ Finset.range 10," in fixed

    def test_in_keyword_in_other_contexts(self):
        """The word `in` in non-big-operator contexts must not be replaced."""
        code = "import Mathlib\n\ndef foo (x : Nat) : Nat :=\n  if x in [1, 2, 3] then x else 0"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        # `in` should still be there (not ∈)
        assert "if x in [1, 2, 3]" in fixed or "x in [1, 2, 3]" in fixed

    def test_let_in_not_touched(self):
        """The `in` in `let x := ... in` must not be replaced."""
        code = "import Mathlib\n\ndef foo := let x := 5 in x + 1"
        pc = PreCompiler()
        fixed, fixes = pc.fix(code)
        assert "let x := 5 in x + 1" in fixed
