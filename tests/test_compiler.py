"""Tests for the Lean compiler module (unit tests, no real Lean binary needed)."""

from pathlib import Path
from unittest.mock import patch, MagicMock
import subprocess

from leanknowledge.lean.compiler import RealLeanCompiler, _contains_sorry
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


class TestSorryDetection:
    def test_sorry_in_tactic_block(self):
        code = "theorem t : True := by\n  sorry"
        assert _contains_sorry(code) is True

    def test_sorry_as_term(self):
        code = "theorem t : True := sorry"
        assert _contains_sorry(code) is True

    def test_no_sorry_clean_proof(self):
        code = "theorem t : True := trivial"
        assert _contains_sorry(code) is False

    def test_sorry_in_line_comment_ignored(self):
        code = "theorem t : True := trivial -- sorry, this is a comment"
        assert _contains_sorry(code) is False

    def test_sorry_in_block_comment_ignored(self):
        code = "/- sorry -/\ntheorem t : True := trivial"
        assert _contains_sorry(code) is False

    def test_sorry_in_docstring_ignored(self):
        code = '/-- A proof that admits sorry in the description. -/\ntheorem t : True := trivial'
        assert _contains_sorry(code) is False

    def test_axiom_not_flagged(self):
        code = "axiom my_dep : SomeType\ntheorem t : True := trivial"
        assert _contains_sorry(code) is False

    def test_sorry_mixed_with_real_tactics(self):
        code = "theorem t : P := by\n  intro h\n  sorry"
        assert _contains_sorry(code) is True

    def test_exact_sorry(self):
        code = "theorem t : P := by\n  exact sorry"
        assert _contains_sorry(code) is True

    def test_compiler_rejects_sorry(self):
        compiler = RealLeanCompiler(project_dir=None)
        success, output = compiler.compile("theorem t : True := by sorry")
        assert success is False
        assert "sorry" in output

    def test_compiler_accepts_axiom(self):
        """Axiom declarations should pass the sorry check (compiled separately)."""
        code = "axiom my_axiom : Nat → Prop"
        assert _contains_sorry(code) is False


class TestLeanREPL:
    @patch("leanknowledge.lean.repl.subprocess.run")
    def test_caches_env(self, mock_run, tmp_path):
        # Two calls: lake env printenv LEAN_PATH, then LEAN_SRC_PATH
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
        # Two printenv calls + lean compile call
        mock_run.side_effect = [
            MagicMock(returncode=0, stdout="/lib/lean\n", stderr=""),   # LEAN_PATH
            MagicMock(returncode=0, stdout="/src/lean\n", stderr=""),   # LEAN_SRC_PATH
            MagicMock(returncode=0, stdout="", stderr=""),              # lean compile
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
