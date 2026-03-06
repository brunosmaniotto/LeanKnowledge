"""Tests for the Lean compiler module (unit tests, no real Lean binary needed)."""

from pathlib import Path
from unittest.mock import patch, MagicMock
import subprocess

from leanknowledge.lean.compiler import RealLeanCompiler
from leanknowledge.lean.repl import LeanREPL


class TestRealLeanCompiler:
    def test_standalone_mode_no_project(self):
        compiler = RealLeanCompiler(project_dir=None)
        assert compiler.project_dir is None
        assert compiler.repl is None

    def test_project_mode_creates_repl(self, tmp_path):
        compiler = RealLeanCompiler(project_dir=tmp_path, use_repl=True)
        assert compiler.repl is not None
        assert isinstance(compiler.repl, LeanREPL)

    def test_project_mode_no_repl(self, tmp_path):
        compiler = RealLeanCompiler(project_dir=tmp_path, use_repl=False)
        assert compiler.repl is None

    @patch("leanknowledge.lean.compiler.subprocess.run")
    def test_standalone_success(self, mock_run):
        mock_run.return_value = MagicMock(returncode=0, stderr="")
        compiler = RealLeanCompiler(project_dir=None)

        success, output = compiler.compile("theorem t : True := trivial")

        assert success is True
        assert output == ""
        mock_run.assert_called_once()

    @patch("leanknowledge.lean.compiler.subprocess.run")
    def test_standalone_failure(self, mock_run):
        mock_run.return_value = MagicMock(
            returncode=1,
            stderr="/tmp/x.lean:1:0: error: type mismatch",
        )
        compiler = RealLeanCompiler(project_dir=None)

        success, output = compiler.compile("theorem t : Nat := \"bad\"")

        assert success is False
        assert "type mismatch" in output

    @patch("leanknowledge.lean.compiler.subprocess.run")
    def test_standalone_timeout(self, mock_run):
        mock_run.side_effect = subprocess.TimeoutExpired(cmd="lean", timeout=120)
        compiler = RealLeanCompiler(project_dir=None)

        success, output = compiler.compile("theorem t := by omega")

        assert success is False
        assert "timed out" in output.lower()


class TestLeanREPL:
    @patch("leanknowledge.lean.repl.subprocess.run")
    def test_caches_env(self, mock_run, tmp_path):
        # Two calls: lake env bash -c "echo $LEAN_PATH", then LEAN_SRC_PATH
        mock_run.side_effect = [
            MagicMock(returncode=0, stdout="/a:/b\n", stderr=""),
            MagicMock(returncode=0, stdout="/c\n", stderr=""),
        ]

        repl = LeanREPL(tmp_path)
        repl._ensure_env()

        assert repl._env_cache is not None
        assert repl._env_cache.get("LEAN_PATH") == "/a:/b"
        assert repl._env_cache.get("LEAN_SRC_PATH") == "/c"

    @patch("leanknowledge.lean.repl.subprocess.run")
    def test_compile_success(self, mock_run, tmp_path):
        # Two env calls + lean compile call
        mock_run.side_effect = [
            MagicMock(returncode=0, stdout="", stderr=""),   # LEAN_PATH
            MagicMock(returncode=0, stdout="", stderr=""),   # LEAN_SRC_PATH
            MagicMock(returncode=0, stdout="", stderr=""),   # lean compile
        ]

        repl = LeanREPL(tmp_path)
        success, output = repl.compile("theorem t : True := trivial")

        assert success is True
        assert output == ""

    def test_invalidate_cache(self, tmp_path):
        repl = LeanREPL(tmp_path)
        repl._env_cache = {"fake": "env"}
        repl.invalidate_cache()
        assert repl._env_cache is None
