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
    def test_type_mismatch(self):
        assert classify_error("type mismatch") == ErrorCategory.TYPE_MISMATCH

    def test_tactic(self):
        assert classify_error("unknown tactic 'simp'") == ErrorCategory.TACTIC

    def test_unsolved_goals(self):
        assert classify_error("unsolved goals") == ErrorCategory.TACTIC

    def test_syntax(self):
        assert classify_error("unexpected token") == ErrorCategory.SYNTAX

    def test_unknown_identifier(self):
        assert classify_error("unknown identifier") == ErrorCategory.SYNTAX

    def test_missing_lemma(self):
        assert classify_error("unknown constant") == ErrorCategory.MISSING_LEMMA

    def test_unknown_namespace(self):
        assert classify_error("unknown namespace") == ErrorCategory.MISSING_LEMMA

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
