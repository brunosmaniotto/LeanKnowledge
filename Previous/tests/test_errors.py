from leanknowledge.lean.errors import (
    classify_error,
    parse_compiler_output,
    is_fundamental_failure,
    ErrorCategory,
    CompilerError
)

SAMPLE_STDERR = """
/path/to/file.lean:10:4: error: type mismatch
  expected: ℕ
  got: ℤ
/path/to/file.lean:15:2: error: unknown tactic 'linarith'
"""

def test_classify_error():
    assert classify_error("type mismatch") == ErrorCategory.TYPE_MISMATCH
    assert classify_error("unknown tactic 'simp'") == ErrorCategory.TACTIC
    assert classify_error("unexpected token") == ErrorCategory.SYNTAX
    assert classify_error("unknown identifier") == ErrorCategory.SYNTAX # logic in code maps 'unknown identifier' to SYNTAX
    assert classify_error("unknown constant") == ErrorCategory.MISSING_LEMMA

def test_parse_compiler_output():
    errors = parse_compiler_output(SAMPLE_STDERR)
    assert len(errors) == 2
    
    e1 = errors[0]
    assert e1.line == 10
    assert e1.category == ErrorCategory.TYPE_MISMATCH
    assert "expected: ℕ" in e1.message
    
    e2 = errors[1]
    assert e2.line == 15
    assert e2.category == ErrorCategory.TACTIC
    assert "unknown tactic" in e2.message

def test_is_fundamental_failure():
    # Case 1: Too many iterations
    errors = [CompilerError(message="err", category=ErrorCategory.TACTIC)]
    assert is_fundamental_failure(errors, iteration=4, max_iterations=6) is True
    assert is_fundamental_failure(errors, iteration=1, max_iterations=6) is False    

    # Case 2: Repeated type mismatches
    type_errors = [
        CompilerError(message="tm", category=ErrorCategory.TYPE_MISMATCH),
        CompilerError(message="tm", category=ErrorCategory.TYPE_MISMATCH),
        CompilerError(message="tm", category=ErrorCategory.TYPE_MISMATCH)
    ]
    assert is_fundamental_failure(type_errors, iteration=1, max_iterations=6) is True
    
    # Case 3: All unknown
    unknown_errors = [
        CompilerError(message="???", category=ErrorCategory.UNKNOWN)
    ]
    # Unknown errors are considered fundamental immediately (cannot be repaired by simple means)
    assert is_fundamental_failure(unknown_errors, iteration=1, max_iterations=6) is True
