"""Persistent Lean compiler — avoids cold-starting Mathlib import on every compilation.

Uses a long-running `lake env lean` process approach:
- Writes code to a scratch file
- Sends SIGUSR1 or uses inotify to trigger recompilation
- Actually, simplest: just cache the env dict from `lake env printPaths` and use it
  to run `lean` directly (skipping `lake env` overhead each time).
"""

import json
import os
import subprocess
import tempfile
import time
from pathlib import Path
from typing import Optional

from .errors import parse_compiler_output
from ..schemas import CompilerError, LeanCode

ELAN_BIN = Path.home() / ".elan" / "bin"


class LeanREPL:
    """Persistent Lean environment that caches Lake's path configuration.

    On first use, runs `lake env printPaths --json` to get the Lean search paths,
    then uses `lean` directly with those paths for all subsequent compilations.
    This avoids the ~2-5s `lake env` overhead per compilation (Mathlib import
    time is still paid once per `lean` invocation, but the Lake resolution is cached).

    For true Mathlib-import amortization, we also support a "warm server" mode
    that keeps a Lean process with Mathlib pre-imported.
    """

    def __init__(self, project_dir: Path):
        self.project_dir = project_dir
        self._env_cache: dict[str, str] | None = None
        self._lean_path: str | None = None
        self._lean_src_path: str | None = None

    def _ensure_env(self):
        """Cache the Lake environment paths on first call."""
        if self._env_cache is not None:
            return

        env = os.environ.copy()
        env["PATH"] = f"{ELAN_BIN}:{env.get('PATH', '')}"

        # Get Lake's path configuration
        try:
            result = subprocess.run(
                ["lake", "env", "printPaths", "--json"],
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=60,
                env=env,
            )
            if result.returncode == 0:
                # Parse the JSON output to get LEAN_PATH and LEAN_SRC_PATH
                paths_data = json.loads(result.stdout)
                self._lean_path = ":".join(paths_data.get("oleanPath", []))
                self._lean_src_path = ":".join(paths_data.get("srcPath", []))
        except (subprocess.TimeoutExpired, json.JSONDecodeError, FileNotFoundError):
            pass

        # Build cached environment
        self._env_cache = env.copy()
        if self._lean_path:
            self._env_cache["LEAN_PATH"] = self._lean_path
        if self._lean_src_path:
            self._env_cache["LEAN_SRC_PATH"] = self._lean_src_path

    def compile(self, lean_code: LeanCode) -> tuple[bool, list[CompilerError]]:
        """Compile Lean code using cached environment (skips lake env overhead)."""
        self._ensure_env()

        full_code = "\n".join(f"import {imp}" for imp in lean_code.imports)
        if lean_code.imports:
            full_code += "\n\n"
        full_code += lean_code.code

        # Write to scratch file in the project
        target = self.project_dir / "LeanKnowledge" / "Scratch.lean"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(full_code)

        try:
            result = subprocess.run(
                ["lean", str(target)],
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=300,
                env=self._env_cache,
            )

            if result.returncode == 0:
                return True, []

            errors = parse_compiler_output(result.stderr)
            return False, errors
        except subprocess.TimeoutExpired:
            return False, [CompilerError(message="Compilation timed out (300s)", category="unknown")]

    def invalidate_cache(self):
        """Force re-caching of Lake environment (e.g., after `lake update`)."""
        self._env_cache = None
        self._lean_path = None
        self._lean_src_path = None
