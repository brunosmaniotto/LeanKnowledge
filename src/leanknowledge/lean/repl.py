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

    def __init__(self, project_dir: Path, scratch_name: str = "Scratch.lean"):
        self.project_dir = project_dir
        self._scratch_name = scratch_name
        self._env_cache: dict[str, str] | None = None

    def _ensure_env(self):
        if self._env_cache is not None:
            return

        env = _lean_env()

        # Extract LEAN_PATH from `lake env` — try printenv first (Lake 5+),
        # fall back to bash subshell (Lake 4.x).
        for var in ("LEAN_PATH", "LEAN_SRC_PATH"):
            try:
                # Lake 5.0.0+: `lake env printenv VAR`
                result = subprocess.run(
                    ["lake", "env", "printenv", var],
                    cwd=self.project_dir,
                    capture_output=True,
                    text=True,
                    timeout=60,
                    env=env,
                    encoding="utf-8",
                    errors="replace",
                )
                if result.returncode == 0 and result.stdout.strip():
                    env[var] = result.stdout.strip()
                    continue

                # Fallback: Lake 4.x `lake env bash -c "echo $VAR"`
                result = subprocess.run(
                    ["lake", "env", "bash", "-c", f"echo ${var}"],
                    cwd=self.project_dir,
                    capture_output=True,
                    text=True,
                    timeout=60,
                    env=env,
                    encoding="utf-8",
                    errors="replace",
                )
                if result.returncode == 0 and result.stdout.strip():
                    env[var] = result.stdout.strip()
            except (subprocess.TimeoutExpired, FileNotFoundError):
                pass

        # If LEAN_PATH wasn't resolved, REPL compilation will fail — signal
        # the caller by NOT setting _env_cache so it falls through.
        if "LEAN_PATH" not in env:
            raise RuntimeError("Failed to resolve LEAN_PATH from Lake")

        self._env_cache = env

    def compile(self, code: str) -> tuple[bool, str]:
        """Compile Lean code using cached environment. Returns (success, output)."""
        self._ensure_env()

        target = self.project_dir / "LeanKnowledge" / self._scratch_name
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
                encoding="utf-8",
                errors="replace",
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
