"""Real Lean 4 compiler interface.

Two modes:
  - Project mode: compiles within a Lake project (has Mathlib access).
    Uses REPL for speed (caches Lake paths), falls back to `lake env lean`.
  - Standalone mode: compiles a temporary file with bare `lean` (no Mathlib).
"""

import os
import subprocess
import tempfile
from pathlib import Path
from typing import Optional

from .repl import LeanREPL, _lean_env

ELAN_BIN = Path.home() / ".elan" / "bin"


class RealLeanCompiler:
    """Lean 4 compiler that calls the real `lean` binary.

    Implements the same interface as the abstract LeanCompiler in
    agents/translator.py: compile(code: str) -> (bool, str).
    """

    def __init__(self, project_dir: Path | None = None, use_repl: bool = True):
        self.project_dir = project_dir
        self._repl: Optional[LeanREPL] = None
        self._use_repl = use_repl

    @property
    def repl(self) -> Optional[LeanREPL]:
        if self._repl is None and self._use_repl and self.project_dir:
            self._repl = LeanREPL(self.project_dir)
        return self._repl

    def compile(self, code: str) -> tuple[bool, str]:
        """Compile Lean 4 code. Returns (success, compiler_output).

        compiler_output is the raw stderr on failure, empty string on success.
        """
        if self.project_dir:
            if self.repl:
                try:
                    return self.repl.compile(code)
                except Exception:
                    pass  # fall back to cold start
            return self._compile_in_project(code)
        return self._compile_standalone(code)

    def _compile_in_project(self, code: str) -> tuple[bool, str]:
        """Compile within a Lake project (has Mathlib access)."""
        target = self.project_dir / "LeanKnowledge" / "Scratch.lean"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(code, encoding="utf-8")

        try:
            result = subprocess.run(
                ["lake", "env", "lean", str(target)],
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=300,
                env=_lean_env(),
            )
        except subprocess.TimeoutExpired:
            return False, "Compilation timed out (300s)"

        # Lean may write errors to stdout or stderr depending on version
        errors = result.stderr or result.stdout
        if result.returncode == 0:
            return True, ""
        return False, errors

    def _compile_standalone(self, code: str) -> tuple[bool, str]:
        """Compile a standalone file (no Mathlib)."""
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".lean", delete=False, encoding="utf-8"
        ) as f:
            f.write(code)
            f.flush()
            tmp_path = f.name

        try:
            result = subprocess.run(
                ["lean", tmp_path],
                capture_output=True,
                text=True,
                timeout=120,
                env=_lean_env(),
            )

            errors = result.stderr or result.stdout
            if result.returncode == 0:
                return True, ""
            return False, errors
        except subprocess.TimeoutExpired:
            return False, "Compilation timed out (120s)"
        finally:
            Path(tmp_path).unlink(missing_ok=True)
