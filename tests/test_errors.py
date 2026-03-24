"""Tests for Lean compiler error parsing and classification."""

from leanknowledge.schemas import CompilerError, ErrorCategory
from leanknowledge.lean.errors import (
    classify_error,
    parse_compiler_output,
    is_fundamental_failure,
)


SAMPLE_STDERR = """
/path/to/file.lean:10:4: error: type mismatch
  expected: ℕ
  got: ℤ
/path/to/file.lean:15:2: error: unknown tactic 'linarith'
"""


class TestClassifyError:
    # ── TYPE_MISMATCH ───────────────────────────────────────────────────
    def test_type_mismatch(self):
        assert classify_error("type mismatch") == ErrorCategory.TYPE_MISMATCH

    def test_application_type_mismatch(self):
        """Regression: 'application type mismatch' must not trigger SYNTAX
        via the generic 'expected' keyword."""
        msg = (
            "application type mismatch\n"
            "  Nat.add_comm\n"
            "expected:\n"
            "  ℕ"
        )
        assert classify_error(msg) == ErrorCategory.TYPE_MISMATCH

    def test_has_type(self):
        assert classify_error("term has type Nat but is expected to have type Int") == ErrorCategory.TYPE_MISMATCH

    def test_expected_type(self):
        assert classify_error("expected type, got something") == ErrorCategory.TYPE_MISMATCH

    def test_invalid_binder_annotation(self):
        assert classify_error("invalid binder annotation, use [inst : Foo] instead") == ErrorCategory.TYPE_MISMATCH

    def test_failed_to_synthesize(self):
        assert classify_error("failed to synthesize instance Decidable") == ErrorCategory.TYPE_MISMATCH

    # ── TACTIC ──────────────────────────────────────────────────────────
    def test_tactic_generic(self):
        assert classify_error("unknown tactic 'simp'") == ErrorCategory.TACTIC

    def test_unsolved_goals(self):
        assert classify_error("unsolved goals") == ErrorCategory.TACTIC

    def test_no_goals(self):
        assert classify_error("no goals to solve") == ErrorCategory.TACTIC

    def test_simp_made_no_progress(self):
        assert classify_error("simp made no progress") == ErrorCategory.TACTIC

    def test_ring_failed(self):
        assert classify_error("ring failed to prove the goal") == ErrorCategory.TACTIC

    def test_omega_failed(self):
        assert classify_error("omega failed to prove the goal") == ErrorCategory.TACTIC

    def test_norm_num_failed(self):
        assert classify_error("norm_num failed to simplify") == ErrorCategory.TACTIC

    def test_linarith_failed(self):
        assert classify_error("linarith failed to prove the goal") == ErrorCategory.TACTIC

    def test_rewrite_tactic_failed(self):
        assert classify_error("rewrite tactic failed, motive is not type correct") == ErrorCategory.TACTIC

    def test_declaration_has_metavariables(self):
        assert classify_error("declaration has metavariables '_example'") == ErrorCategory.TACTIC

    def test_maximum_recursion_depth(self):
        assert classify_error("maximum recursion depth has been reached") == ErrorCategory.TACTIC

    # ── MISSING_LEMMA ───────────────────────────────────────────────────
    def test_missing_lemma(self):
        assert classify_error("unknown constant") == ErrorCategory.MISSING_LEMMA

    def test_unknown_namespace(self):
        assert classify_error("unknown namespace") == ErrorCategory.MISSING_LEMMA

    def test_unknown_identifier(self):
        """'unknown identifier' is MISSING_LEMMA (usually a missing import)."""
        assert classify_error("unknown identifier 'Nat.foo'") == ErrorCategory.MISSING_LEMMA

    def test_not_found(self):
        assert classify_error("declaration 'Foo.bar' not found") == ErrorCategory.MISSING_LEMMA

    def test_function_expected(self):
        assert classify_error("function expected at\n  Nat.prime") == ErrorCategory.MISSING_LEMMA

    # ── SYNTAX ──────────────────────────────────────────────────────────
    def test_unexpected_token(self):
        assert classify_error("unexpected token") == ErrorCategory.SYNTAX

    def test_expected_token(self):
        assert classify_error("expected token ')'") == ErrorCategory.SYNTAX

    def test_expected_command(self):
        assert classify_error("expected command") == ErrorCategory.SYNTAX

    def test_cannot_evaluate(self):
        assert classify_error("cannot evaluate expression") == ErrorCategory.SYNTAX

    def test_ambiguous(self):
        assert classify_error("ambiguous, possible interpretations") == ErrorCategory.SYNTAX

    def test_not_a_theorem(self):
        assert classify_error("not a theorem") == ErrorCategory.SYNTAX

    def test_generic_expected_syntax(self):
        """The generic 'expected' keyword should still catch remaining syntax errors."""
        assert classify_error("expected ':='") == ErrorCategory.SYNTAX

    # ── UNKNOWN ─────────────────────────────────────────────────────────
    def test_fallback(self):
        assert classify_error("something weird happened") == ErrorCategory.UNKNOWN


class TestParseCompilerOutput:
    def test_parse_two_errors(self):
        errors = parse_compiler_output(SAMPLE_STDERR)
        assert len(errors) == 2

        e1 = errors[0]
        assert e1.line == 10
        assert e1.column == 4
        assert e1.category == ErrorCategory.TYPE_MISMATCH
        assert "expected: ℕ" in e1.message

        e2 = errors[1]
        assert e2.line == 15
        assert e2.column == 2
        assert e2.category == ErrorCategory.TACTIC
        assert "unknown tactic" in e2.message

    def test_empty_stderr(self):
        assert parse_compiler_output("") == []

    def test_unparseable_stderr_captured_raw(self):
        errors = parse_compiler_output("PANIC: internal error")
        assert len(errors) == 1
        assert errors[0].category == ErrorCategory.UNKNOWN
        assert "PANIC" in errors[0].message

    def test_single_error(self):
        stderr = "/foo.lean:1:0: error: unknown constant 'Nat.add_comm'"
        errors = parse_compiler_output(stderr)
        assert len(errors) == 1
        assert errors[0].line == 1
        assert errors[0].category == ErrorCategory.MISSING_LEMMA


class TestIsFundamentalFailure:
    def test_too_many_iterations(self):
        errors = [CompilerError(message="err", category=ErrorCategory.TACTIC)]
        assert is_fundamental_failure(errors, iteration=4, max_iterations=6) is True
        assert is_fundamental_failure(errors, iteration=1, max_iterations=6) is False

    def test_repeated_type_mismatches(self):
        errors = [
            CompilerError(message="tm", category=ErrorCategory.TYPE_MISMATCH)
            for _ in range(3)
        ]
        assert is_fundamental_failure(errors, iteration=1, max_iterations=6) is True

    def test_all_unknown(self):
        errors = [CompilerError(message="???", category=ErrorCategory.UNKNOWN)]
        assert is_fundamental_failure(errors, iteration=1, max_iterations=6) is True

    def test_recoverable(self):
        errors = [CompilerError(message="m", category=ErrorCategory.TACTIC)]
        assert is_fundamental_failure(errors, iteration=1, max_iterations=10) is False
