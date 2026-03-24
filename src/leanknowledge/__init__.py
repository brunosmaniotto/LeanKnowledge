"""LeanKnowledge — multi-agent pipeline for formal mathematics."""

from .dependency_graph import DependencyGraph, build_graph  # noqa: F401

import os
import sys

# ---------------------------------------------------------------------------
# Force UTF-8 mode on Windows.
#
# Python on Windows defaults to the ANSI code page (usually cp1252) for
# file I/O and stdout/stderr. Our prompts and Lean code contain Unicode
# math symbols (∏, ∀, →, etc.) which crash under cp1252.
#
# Two-layer fix:
#   1. Set PYTHONUTF8=1 for any child processes (e.g., subprocess calls
#      that spawn Python). Won't help the current process, but prevents
#      the same issue in workers.
#   2. Reconfigure stdout/stderr to UTF-8 so print() never crashes.
#
# For file reads/writes, all code must pass encoding="utf-8" explicitly.
# The test_utf8_encoding test enforces this via grep.
# ---------------------------------------------------------------------------
if sys.platform == "win32":
    os.environ.setdefault("PYTHONUTF8", "1")
    for _stream_name in ("stdout", "stderr"):
        _stream = getattr(sys, _stream_name, None)
        if _stream and hasattr(_stream, "reconfigure"):
            try:
                _stream.reconfigure(encoding="utf-8", errors="replace")
            except Exception:
                pass
