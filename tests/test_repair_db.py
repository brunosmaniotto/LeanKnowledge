"""Tests for the three-tier deterministic repair engine."""

import pytest

from leanknowledge.schemas import CompilerError, ErrorCategory
from leanknowledge.lean.repair_db import RepairDB


@pytest.fixture
def repair_db():
    return RepairDB()


class TestTierA:
    def test_missing_tactic_import(self, repair_db):
        code = "theorem t : True := by linarith"
        error = CompilerError(
            message="unknown tactic 'linarith'",
            category=ErrorCategory.TACTIC,
            line=1,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "import Mathlib.Tactic.Linarith" in fixed
        assert "Tier A" in fixes[0]

    def test_existing_import_not_duplicated(self, repair_db):
        code = "import Mathlib.Tactic.Linarith\ntheorem t : True := by linarith"
        error = CompilerError(
            message="unknown tactic 'linarith'",
            category=ErrorCategory.TACTIC,
            line=2,
        )

        fixed, fixes = repair_db.try_repair(code, [error])
        # Import already exists, so code is unchanged -> returns None
        assert fixed is None

    def test_prop_bool(self, repair_db):
        code = "def f (x : Nat) := if x > 0 then 1 else 0"
        error = CompilerError(
            message="type mismatch: expected Prop, got Bool",
            category=ErrorCategory.TYPE_MISMATCH,
            line=1,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "if ((x > 0) : Prop) then" in fixed

    def test_trivial_goal_true(self, repair_db):
        code = "theorem t : True := by\n  sorry"
        error = CompilerError(
            message="unsolved goals\n⊢ True",
            category=ErrorCategory.TACTIC,
            line=2,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "trivial" in fixed

    def test_fuzzy_match_identifier(self):
        db = RepairDB(lean_names=["Nat.add_comm", "Nat.mul_comm", "Int.add_assoc"])
        code = "theorem t := Nat.ad_comm"
        error = CompilerError(
            message="unknown identifier 'Nat.ad_comm'",
            category=ErrorCategory.SYNTAX,
            line=1,
        )

        fixed, fixes = db.try_repair(code, [error])

        assert fixed is not None
        assert "Nat.add_comm" in fixed


class TestMissingOpen:
    """Tests for _fix_missing_open — handles function expected / unknown bare name."""

    def test_function_expected_with_qualified_name_in_error(self, repair_db):
        """'function expected' error mentioning Finset.card → injects open Finset."""
        code = "import Mathlib\ntheorem t : Finset.card s = 0 := by sorry"
        error = CompilerError(
            message="function expected at\n  Finset.card\nterm has type\n  ?m",
            category=ErrorCategory.SYNTAX,
            line=2,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "open Finset" in fixed
        assert "Tier A" in fixes[0]

    def test_function_expected_extracts_from_error_line(self, repair_db):
        """'function expected' without identifier in message → looks at error line."""
        code = "import Mathlib\ntheorem t := Filter.Tendsto f l l'"
        error = CompilerError(
            message="function expected",
            category=ErrorCategory.SYNTAX,
            line=2,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "open Filter" in fixed

    def test_unknown_identifier_bare_name_tendsto(self, repair_db):
        """'unknown identifier' with bare 'Tendsto' → injects open Filter."""
        code = "import Mathlib\ntheorem t := Tendsto f l l'"
        error = CompilerError(
            message="unknown identifier 'Tendsto'",
            category=ErrorCategory.SYNTAX,
            line=2,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "open Filter" in fixed

    def test_unknown_identifier_bare_name_card(self, repair_db):
        """'unknown identifier' with bare 'card' → injects open Finset."""
        code = "import Mathlib\ntheorem t := card s"
        error = CompilerError(
            message="unknown identifier 'card'",
            category=ErrorCategory.SYNTAX,
            line=2,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "open Finset" in fixed

    def test_already_open_namespace_no_change(self, repair_db):
        """When namespace is already open, no change is made."""
        code = "import Mathlib\nopen Finset\ntheorem t := card s"
        error = CompilerError(
            message="function expected at\n  Finset.card",
            category=ErrorCategory.SYNTAX,
            line=3,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        # Already open → no fix applied
        assert fixed is None

    def test_already_open_bare_name_no_change(self, repair_db):
        """'unknown identifier' bare name but namespace already open → no fix."""
        code = "import Mathlib\nopen Filter\ntheorem t := Tendsto f l l'"
        error = CompilerError(
            message="unknown identifier 'Tendsto'",
            category=ErrorCategory.SYNTAX,
            line=3,
        )

        fixed, fixes = repair_db.try_repair(code, [error])
        assert fixed is None

    def test_open_inserted_after_imports(self, repair_db):
        """The `open` statement is inserted after the last import/open line."""
        code = "import Mathlib\nimport SomeOther\ntheorem t := Finset.card s"
        error = CompilerError(
            message="function expected at\n  Finset.card",
            category=ErrorCategory.SYNTAX,
            line=3,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        lines = fixed.splitlines()
        # open Finset should appear after the imports
        open_idx = next(i for i, l in enumerate(lines) if "open Finset" in l)
        last_import = max(i for i, l in enumerate(lines) if l.startswith("import "))
        assert open_idx > last_import

    def test_multiple_function_expected_errors(self, repair_db):
        """Multiple 'function expected' errors → handles all of them."""
        code = (
            "import Mathlib\n"
            "theorem t1 := Finset.card s\n"
            "theorem t2 := Filter.Tendsto f l l'"
        )
        errors = [
            CompilerError(
                message="function expected at\n  Finset.card",
                category=ErrorCategory.SYNTAX,
                line=2,
            ),
            CompilerError(
                message="function expected at\n  Filter.Tendsto",
                category=ErrorCategory.SYNTAX,
                line=3,
            ),
        ]

        fixed, fixes = repair_db.try_repair(code, errors)

        assert fixed is not None
        assert "open Finset" in fixed
        assert "open Filter" in fixed
        assert len(fixes) == 2

    def test_bare_name_not_in_lookup_no_change(self, repair_db):
        """'unknown identifier' with a bare name NOT in the lookup table → no fix."""
        code = "import Mathlib\ntheorem t := foobar x"
        error = CompilerError(
            message="unknown identifier 'foobar'",
            category=ErrorCategory.SYNTAX,
            line=2,
        )

        fixed, fixes = repair_db.try_repair(code, [error])
        assert fixed is None

    def test_qualified_unknown_identifier_not_handled(self, repair_db):
        """'unknown identifier' with a qualified name (has dot) → not handled by _fix_missing_open."""
        code = "import Mathlib\ntheorem t := Foo.bar x"
        error = CompilerError(
            message="unknown identifier 'Foo.bar'",
            category=ErrorCategory.SYNTAX,
            line=2,
        )
        # This should NOT be handled by _fix_missing_open (qualified names go
        # through _fix_unknown_identifier instead). With no lean_names, it
        # returns None.
        fixed, fixes = repair_db.try_repair(code, [error])
        assert fixed is None


class TestTierB:
    def test_type_coercion_nat_to_int(self, repair_db):
        code = "def f (n : ℕ) : ℤ :=\n  n"
        error = CompilerError(
            message="type mismatch\n      expected: ℤ\n      got: ℕ",
            category=ErrorCategory.TYPE_MISMATCH,
            line=2,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "↑n" in fixed
        assert "Tier B" in fixes[0]

    def test_namespace_rename(self, repair_db):
        code = "example := Finset.sum_comm"
        error = CompilerError(
            message="unknown constant 'Finset.sum_comm'",
            category=ErrorCategory.MISSING_LEMMA,
            line=1,
        )

        fixed, fixes = repair_db.try_repair(code, [error])

        assert fixed is not None
        assert "Finset.sum_comm'" in fixed


class TestNoRepair:
    def test_unknown_error_returns_none(self, repair_db):
        code = "theorem t : False := sorry"
        error = CompilerError(
            message="random error",
            category=ErrorCategory.UNKNOWN,
            line=1,
        )

        fixed, fixes = repair_db.try_repair(code, [error])
        assert fixed is None
        assert len(fixes) == 0

    def test_empty_errors(self, repair_db):
        fixed, fixes = repair_db.try_repair("code", [])
        assert fixed is None
        assert len(fixes) == 0


class TestMultipleErrors:
    def test_fixes_multiple_same_line_type(self, repair_db):
        """Two errors that don't shift line numbers."""
        code = "def f (n : ℕ) : ℤ :=\n  n\ndef g (m : ℕ) : ℝ :=\n  m"
        errors = [
            CompilerError(
                message="type mismatch\n      expected: ℤ\n      got: ℕ",
                category=ErrorCategory.TYPE_MISMATCH,
                line=2,
            ),
            CompilerError(
                message="type mismatch\n      expected: ℝ\n      got: ℕ",
                category=ErrorCategory.TYPE_MISMATCH,
                line=4,
            ),
        ]

        fixed, fixes = repair_db.try_repair(code, errors)

        assert fixed is not None
        assert len(fixes) == 2
        assert "Tier B" in fixes[0]
        assert "Tier B" in fixes[1]

    def test_import_fix_applied(self, repair_db):
        """Import fix works as one of multiple errors (others may be stale after line shift)."""
        code = "theorem t : True := by linarith"
        errors = [
            CompilerError(
                message="unknown tactic 'linarith'",
                category=ErrorCategory.TACTIC,
                line=1,
            ),
        ]

        fixed, fixes = repair_db.try_repair(code, errors)

        assert fixed is not None
        assert "import Mathlib.Tactic.Linarith" in fixed
        assert len(fixes) == 1
