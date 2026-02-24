"""Interface to the Lean 4 compiler."""

import os
import subprocess
import tempfile
from pathlib import Path
from typing import Optional

from .errors import parse_compiler_output
from ..schemas import CompilerError, LeanCode

ELAN_BIN = Path.home() / ".elan" / "bin"


def _lean_env() -> dict[str, str]:
    """Return env with elan bin on PATH."""
    env = os.environ.copy()
    env["PATH"] = f"{ELAN_BIN}:{env.get('PATH', '')}"
    return env


class LeanCompiler:
    def __init__(self, project_dir: Path | None = None, use_repl: bool = True):
        self.project_dir = project_dir
        self._repl: Optional["LeanREPL"] = None
        self._use_repl = use_repl

    @property
    def repl(self):
        if self._repl is None and self._use_repl and self.project_dir:
            from .repl import LeanREPL
            self._repl = LeanREPL(self.project_dir)
        return self._repl

    def compile(self, lean_code: LeanCode) -> tuple[bool, list[CompilerError]]:
        full_code = "\n".join(f"import {imp}" for imp in lean_code.imports)
        if lean_code.imports:
            full_code += "\n\n"
        full_code += lean_code.code

        if self.project_dir:
            # Try REPL first for speed, fall back to cold start
            if self.repl:
                try:
                    return self.repl.compile(lean_code)
                except Exception:
                    # Fall back to cold start if REPL fails
                    pass
            return self._compile_in_project(full_code)
        else:
            return self._compile_standalone(full_code)

    def _compile_in_project(self, code: str) -> tuple[bool, list[CompilerError]]:
        """Compile within a Lake project (has Mathlib access)."""
        target = self.project_dir / "LeanKnowledge" / "Scratch.lean"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(code)

        result = subprocess.run(
            ["lake", "env", "lean", str(target)],
            cwd=self.project_dir,
            capture_output=True,
            text=True,
            timeout=300,
            env=_lean_env(),
        )

        if result.returncode == 0:
            return True, []

        errors = parse_compiler_output(result.stderr)
        return False, errors

    def _compile_standalone(self, code: str) -> tuple[bool, list[CompilerError]]:
        """Compile a standalone file (no Mathlib)."""
        with tempfile.NamedTemporaryFile(mode="w", suffix=".lean", delete=False) as f:
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

            if result.returncode == 0:
                return True, []

            errors = parse_compiler_output(result.stderr)
            return False, errors
        finally:
            Path(tmp_path).unlink(missing_ok=True)
