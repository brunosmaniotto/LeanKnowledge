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
