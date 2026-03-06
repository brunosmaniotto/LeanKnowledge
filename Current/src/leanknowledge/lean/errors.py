"""Error classification and parsing for Lean 4 compiler output."""

import re

from ..schemas import CompilerError, ErrorCategory


def classify_error(message: str) -> ErrorCategory:
    """Classify a Lean compiler error message into an actionable category."""
    msg = message.lower()

    if any(kw in msg for kw in ["tactic", "unsolved goals", "no goals"]):
        return ErrorCategory.TACTIC

    if any(kw in msg for kw in ["type mismatch", "has type", "expected type"]):
        return ErrorCategory.TYPE_MISMATCH

    if any(kw in msg for kw in ["expected", "unexpected token", "unknown identifier"]):
        return ErrorCategory.SYNTAX

    if any(kw in msg for kw in ["unknown constant", "unknown namespace", "not found"]):
        return ErrorCategory.MISSING_LEMMA

    return ErrorCategory.UNKNOWN


def parse_compiler_output(stderr: str) -> list[CompilerError]:
    """Parse Lean 4 compiler stderr into structured errors."""
    errors = []
    # Lean errors look like: file.lean:10:4: error: message
    pattern = re.compile(
        r"(?:.*?):(\d+):(\d+):\s*error:\s*(.*?)(?=\n\S|\Z)", re.DOTALL
    )

    for match in pattern.finditer(stderr):
        line = int(match.group(1))
        col = int(match.group(2))
        msg = match.group(3).strip()
        errors.append(
            CompilerError(
                line=line,
                column=col,
                message=msg,
                category=classify_error(msg),
            )
        )

    # If we couldn't parse structured errors but there's content, capture it raw
    if not errors and stderr.strip():
        errors.append(
            CompilerError(
                message=stderr.strip(),
                category=ErrorCategory.UNKNOWN,
            )
        )

    return errors


def is_fundamental_failure(
    errors: list[CompilerError], iteration: int, max_iterations: int
) -> bool:
    """Determine if errors indicate a fundamental proof strategy problem.

    Heuristics:
    - More than half the iterations used with no progress
    - Repeated type mismatches (>= 3) suggest wrong approach
    - All errors are UNKNOWN (can't even classify them)
    """
    if iteration >= max_iterations // 2:
        return True

    type_mismatch_count = sum(
        1 for e in errors if e.category == ErrorCategory.TYPE_MISMATCH
    )
    if type_mismatch_count >= 3:
        return True

    if all(e.category == ErrorCategory.UNKNOWN for e in errors):
        return True

    return False
