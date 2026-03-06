"""Persistent Lean environment that caches Lake's path configuration.

On first use, runs `lake env printPaths --json` to get the Lean search paths,
then uses `lean` directly with those paths for all subsequent compilations.
This avoids the ~2-5s `lake env` overhead per compilation.
"""

import json
import os
import subprocess
import tempfile
from pathlib import Path

from .errors import parse_compiler_output

ELAN_BIN = Path.home() / ".elan" / "bin"


def _lean_env() -> dict[str, str]:
    """Return env with elan bin on PATH."""
    env = os.environ.copy()
    env["PATH"] = f"{ELAN_BIN}{os.pathsep}{env.get('PATH', '')}"
    return env


class LeanREPL:
    """Cached Lean environment that skips Lake resolution overhead.

    First call runs `lake env printPaths --json` and caches LEAN_PATH
    and LEAN_SRC_PATH. Subsequent compilations use `lean` directly.
    """

    def __init__(self, project_dir: Path):
        self.project_dir = project_dir
        self._env_cache: dict[str, str] | None = None

    def _ensure_env(self):
        if self._env_cache is not None:
            return

        env = _lean_env()

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
                paths_data = json.loads(result.stdout)
                lean_path = os.pathsep.join(paths_data.get("oleanPath", []))
                lean_src_path = os.pathsep.join(paths_data.get("srcPath", []))
                if lean_path:
                    env["LEAN_PATH"] = lean_path
                if lean_src_path:
                    env["LEAN_SRC_PATH"] = lean_src_path
        except (subprocess.TimeoutExpired, json.JSONDecodeError, FileNotFoundError):
            pass

        self._env_cache = env

    def compile(self, code: str) -> tuple[bool, str]:
        """Compile Lean code using cached environment. Returns (success, output)."""
        self._ensure_env()

        target = self.project_dir / "LeanKnowledge" / "Scratch.lean"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(code, encoding="utf-8")

        try:
            result = subprocess.run(
                ["lean", str(target)],
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=300,
                env=self._env_cache,
            )

            # Lean may write errors to stdout or stderr depending on version
            errors = result.stderr or result.stdout
            if result.returncode == 0:
                return True, ""
            return False, errors
        except subprocess.TimeoutExpired:
            return False, "Compilation timed out (300s)"

    def invalidate_cache(self):
        """Force re-caching of Lake environment (e.g., after `lake update`)."""
        self._env_cache = None
