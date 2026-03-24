"""Real Lean 4 compiler interface.

Two modes:
  - Project mode: compiles within a Lake project (has Mathlib access).
    Uses REPL for speed (caches Lake paths), falls back to `lake env lean`.
  - Standalone mode: compiles a temporary file with bare `lean` (no Mathlib).
"""

import os
import re
import subprocess
import tempfile
from pathlib import Path
from typing import Optional

from .repl import LeanREPL, _lean_env


def _contains_sorry(code: str) -> bool:
    """Check if Lean code contains `sorry` as a tactic/term (not in comments).

    Returns True if `sorry` is used as a proof placeholder.
    Does NOT flag `axiom` declarations — those are intentional axiomatizations.
    """
    # Strip all block comments /- ... -/ (possibly nested) first
    stripped_code = _strip_block_comments(code)

    for line in stripped_code.splitlines():
        # Remove inline line comments
        comment_pos = line.find("--")
        if comment_pos >= 0:
            line = line[:comment_pos]

        if re.search(r'\bsorry\b', line):
            return True
    return False


def _strip_block_comments(code: str) -> str:
    """Remove all /- ... -/ block comments (supporting nesting)."""
    result = []
    depth = 0
    i = 0
    while i < len(code):
        if i < len(code) - 1 and code[i:i+2] == "/-":
            depth += 1
            i += 2
        elif i < len(code) - 1 and code[i:i+2] == "-/":
            depth = max(0, depth - 1)
            i += 2
        elif depth == 0:
            result.append(code[i])
            i += 1
        else:
            i += 1
    return "".join(result)

ELAN_BIN = Path.home() / ".elan" / "bin"


class RealLeanCompiler:
    """Lean 4 compiler that calls the real `lean` binary.

    Implements the same interface as the abstract LeanCompiler in
    agents/translator.py: compile(code: str) -> (bool, str).
    """

    def __init__(
        self,
        project_dir: Path | None = None,
        use_repl: bool = True,
        worker_id: int | str | None = None,
    ):
        self.project_dir = project_dir
        self._repl: Optional[LeanREPL] = None
        self._use_repl = use_repl
        # Unique scratch filename for parallel execution
        self._scratch_name = f"Scratch_{worker_id}.lean" if worker_id is not None else "Scratch.lean"

    @property
    def repl(self) -> Optional[LeanREPL]:
        if self._repl is None and self._use_repl and self.project_dir:
            self._repl = LeanREPL(self.project_dir, scratch_name=self._scratch_name)
        return self._repl

    def compile(self, code: str) -> tuple[bool, str]:
        """Compile Lean 4 code. Returns (success, compiler_output).

        compiler_output is the raw stderr on failure, empty string on success.
        Code containing `sorry` is rejected even if Lean accepts it —
        `sorry` is an unsound proof placeholder, not a real proof.
        `axiom` declarations are allowed (intentional axiomatizations).
        """
        # Pre-check: reject sorry before wasting a compilation
        if _contains_sorry(code):
            return False, (
                "error: declaration uses 'sorry' — proof is incomplete. "
                "All goals must be closed without sorry. "
                "Use `axiom` declarations for intentional axiomatizations."
            )

        # Import-free code doesn't need Mathlib — skip Lake entirely to avoid
        # the 600s timeout that occurs when the Mathlib .olean cache isn't built.
        has_imports = bool(re.search(r'^\s*import\s+\S', code, re.MULTILINE))
        if not has_imports:
            return self._compile_standalone(code)

        if self.project_dir:
            if self.repl:
                try:
                    return self.repl.compile(code)
                except Exception:
                    pass  # fall back to cold start
            return self._compile_in_project(code)
        return self._compile_standalone(code)

    def _compile_in_project(self, code: str) -> tuple[bool, str]:
        """Compile within a Lake project (has Mathlib access).

        Uses `lake lean` (Lake 5.0.0+) which is the native command.
        Falls back to `lake env lean` for older Lake versions.
        """
        target = self.project_dir / "LeanKnowledge" / self._scratch_name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(code, encoding="utf-8")

        try:
            # Lake 5.0.0+: `lake lean <file>`
            result = subprocess.run(
                ["lake", "lean", str(target)],
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=600,
                env=_lean_env(),
                encoding="utf-8",
                errors="replace",
            )
        except subprocess.TimeoutExpired:
            return False, "Compilation timed out (600s)"

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
                encoding="utf-8",
                errors="replace",
            )

            errors = result.stderr or result.stdout
            if result.returncode == 0:
                return True, ""
            return False, errors
        except subprocess.TimeoutExpired:
            return False, "Compilation timed out (120s)"
        finally:
            Path(tmp_path).unlink(missing_ok=True)
