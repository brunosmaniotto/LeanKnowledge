"""Enforce explicit UTF-8 encoding on all file reads in the codebase.

On Windows, Python defaults to cp1252. Our prompts and Lean code contain
Unicode math symbols that crash under cp1252. This test greps the source
tree for bare read_text() and open() calls that don't specify encoding,
preventing regressions.
"""

import re
from pathlib import Path

SRC_DIR = Path(__file__).resolve().parents[1] / "src" / "leanknowledge"

# Patterns that indicate a text file read without explicit encoding.
# We flag: .read_text() with no args, open(...) in text mode without encoding=
BARE_READ_TEXT = re.compile(r"\.read_text\(\s*\)")
BARE_OPEN = re.compile(
    r"""open\(          # open(
    [^)]*               # any args
    \)                  # closing paren
    """,
    re.VERBOSE,
)


def _scan_file(path: Path) -> list[tuple[int, str]]:
    """Return list of (line_number, line) with bare text reads."""
    violations = []
    try:
        lines = path.read_text(encoding="utf-8").splitlines()
    except Exception:
        return []

    for i, line in enumerate(lines, 1):
        stripped = line.strip()
        # Skip comments
        if stripped.startswith("#"):
            continue

        # Check for .read_text() without encoding
        if BARE_READ_TEXT.search(line):
            violations.append((i, stripped))
            continue

        # Check for open() in text mode without encoding=
        # We only flag opens that look like text reads (not "rb", "wb", etc.)
        if "open(" in line and "encoding" not in line:
            # Skip binary modes
            if any(mode in line for mode in ('"rb"', "'rb'", '"wb"', "'wb'",
                                              '"ab"', "'ab'", "read_bytes")):
                continue
            # Skip non-file opens (urllib, pymupdf, etc.)
            if any(skip in line for skip in ("urlopen", "pymupdf", "tempfile",
                                              "NamedTemporaryFile", "TemporaryFile")):
                continue
            # Flag if it looks like a file open for reading/writing text
            if re.search(r'\bopen\s*\(', line):
                violations.append((i, stripped))

    return violations


def test_no_bare_read_text():
    """All .read_text() calls must specify encoding='utf-8'."""
    all_violations = []
    for py_file in SRC_DIR.rglob("*.py"):
        if "__pycache__" in str(py_file):
            continue
        violations = _scan_file(py_file)
        for lineno, line in violations:
            rel = py_file.relative_to(SRC_DIR)
            all_violations.append(f"  {rel}:{lineno}: {line}")

    if all_violations:
        msg = (
            "Found file reads without explicit encoding='utf-8'.\n"
            "On Windows, Python defaults to cp1252 which crashes on Unicode math.\n"
            "Fix: add encoding='utf-8' to all read_text() and open() calls.\n\n"
            + "\n".join(all_violations)
        )
        raise AssertionError(msg)
