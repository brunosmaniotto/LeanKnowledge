"""Error classification and parsing for Lean 4 compiler output."""

import re

from ..schemas import CompilerError, ErrorCategory


def classify_error(message: str) -> ErrorCategory:
    """Classify a Lean compiler error message into an actionable category.

    Uses an ordered list of (pattern, category) tuples checked from most
    specific to least specific.  The first match wins, so specific phrases
    like "application type mismatch" are tested before generic substrings
    like "expected".
    """
    msg = message.lower()

    # Ordered most-specific → least-specific.  First match wins.
    _PATTERNS: list[tuple[str, ErrorCategory]] = [
        # ── TYPE_MISMATCH (specific phrases first) ──────────────────────
        ("application type mismatch", ErrorCategory.TYPE_MISMATCH),
        ("type mismatch",            ErrorCategory.TYPE_MISMATCH),
        ("has type",                 ErrorCategory.TYPE_MISMATCH),
        ("expected type",            ErrorCategory.TYPE_MISMATCH),
        ("invalid binder annotation", ErrorCategory.TYPE_MISMATCH),
        ("failed to synthesize",     ErrorCategory.TYPE_MISMATCH),

        # ── TACTIC (specific tactic failures before generic keyword) ────
        ("unsolved goals",           ErrorCategory.TACTIC),
        ("no goals",                 ErrorCategory.TACTIC),
        ("simp made no progress",    ErrorCategory.TACTIC),
        ("ring failed",              ErrorCategory.TACTIC),
        ("omega failed",             ErrorCategory.TACTIC),
        ("norm_num failed",          ErrorCategory.TACTIC),
        ("linarith failed",          ErrorCategory.TACTIC),
        ("rewrite tactic failed",    ErrorCategory.TACTIC),
        ("declaration has metavariables", ErrorCategory.TACTIC),
        ("maximum recursion depth",  ErrorCategory.TACTIC),
        ("tactic",                   ErrorCategory.TACTIC),   # generic fallback

        # ── MISSING_LEMMA ───────────────────────────────────────────────
        ("unknown constant",         ErrorCategory.MISSING_LEMMA),
        ("unknown namespace",        ErrorCategory.MISSING_LEMMA),
        ("unknown identifier",       ErrorCategory.MISSING_LEMMA),
        ("not found",                ErrorCategory.MISSING_LEMMA),
        ("function expected",        ErrorCategory.MISSING_LEMMA),

        # ── SYNTAX (generic patterns last so they don't shadow above) ──
        ("unexpected token",         ErrorCategory.SYNTAX),
        ("expected token",           ErrorCategory.SYNTAX),
        ("expected command",         ErrorCategory.SYNTAX),
        ("cannot evaluate",          ErrorCategory.SYNTAX),
        ("ambiguous",                ErrorCategory.SYNTAX),
        ("not a theorem",            ErrorCategory.SYNTAX),
        ("expected",                 ErrorCategory.SYNTAX),   # generic fallback
    ]

    for pattern, category in _PATTERNS:
        if pattern in msg:
            return category

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
