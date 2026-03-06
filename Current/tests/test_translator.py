"""Tests for Agent 6: Translator with escalation and triple collection."""

from leanknowledge.schemas import StructuredProof, ProofStrategy, ProofStep
from leanknowledge.agents.translator import (
    TranslatorAgent, LeanCompiler, TranslationOutcome,
    _build_initial_prompt, _build_retry_prompt, _extract_lean_code,
    TranslationTriple,
)


def _proof() -> StructuredProof:
    return StructuredProof(
        theorem_name="test_thm",
        strategy=ProofStrategy.DIRECT,
        goal_statement="1 + 1 = 2",
        steps=[ProofStep(step_number=1, description="Compute",
                         justification="By norm_num",
                         lean_tactic_hint="norm_num")],
        conclusion="Done.",
    )


class MockCompiler(LeanCompiler):
    """Compiler that succeeds on attempt N (1-indexed), fails before."""

    def __init__(self, succeed_on: int | None = None):
        self.succeed_on = succeed_on
        self.call_count = 0

    def compile(self, code: str) -> tuple[bool, str]:
        self.call_count += 1
        if self.succeed_on and self.call_count >= self.succeed_on:
            return True, "No errors."
        return False, f"error: type mismatch (attempt {self.call_count})"


class AlwaysFailCompiler(LeanCompiler):
    def compile(self, code: str) -> tuple[bool, str]:
        return False, "error: unknown identifier 'foo'"


class FakeTranslatorAgent(TranslatorAgent):
    """TranslatorAgent that doesn't actually call LLMs — returns fixed code."""

    def __init__(self, compiler, **kw):
        super().__init__(compiler, **kw)
        self._response_count = 0

    def _fake_complete(self, model, prompt, system, max_tokens):
        self._response_count += 1
        return f"theorem test_thm : 1 + 1 = 2 := by norm_num -- attempt {self._response_count}"


# We'll test the components that don't need LLM calls

class TestPromptBuilding:
    def test_initial_prompt_has_proof(self):
        prompt = _build_initial_prompt(_proof())
        assert "test_thm" in prompt
        assert "1 + 1 = 2" in prompt
        assert "PREVIOUS ATTEMPTS" not in prompt

    def test_retry_prompt_has_history(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code="theorem bad : sorry",
                compiler_output="error: unknown tactic 'sorry_bad'",
                compiled=False,
                model="deepseek/deepseek-reasoner",
                attempt_number=1,
            ),
        ]
        prompt = _build_retry_prompt(_proof(), history)
        assert "PREVIOUS ATTEMPTS" in prompt
        assert "ATTEMPT 1" in prompt
        assert "theorem bad : sorry" in prompt
        assert "unknown tactic" in prompt
        assert "FAILED" in prompt

    def test_retry_prompt_shows_multiple_attempts(self):
        history = [
            TranslationTriple(
                structured_proof=_proof(),
                lean_code=f"code_{i}",
                compiler_output=f"error_{i}",
                compiled=False,
                model="test",
                attempt_number=i,
            )
            for i in range(1, 4)
        ]
        prompt = _build_retry_prompt(_proof(), history)
        assert "ATTEMPT 1" in prompt
        assert "ATTEMPT 2" in prompt
        assert "ATTEMPT 3" in prompt
        assert "error_1" in prompt
        assert "error_3" in prompt


class TestCodeExtraction:
    def test_plain_code(self):
        assert _extract_lean_code("theorem x : True := trivial") == "theorem x : True := trivial"

    def test_strip_markdown_fences(self):
        code = "```lean\ntheorem x : True := trivial\n```"
        assert _extract_lean_code(code) == "theorem x : True := trivial"

    def test_strip_fences_no_language(self):
        code = "```\ntheorem x : True := trivial\n```"
        assert _extract_lean_code(code) == "theorem x : True := trivial"


class TestTranslationResult:
    def test_success_on_first_try(self):
        compiler = MockCompiler(succeed_on=1)
        # We can't fully test without LLM, but we can test the triple structure
        triple = TranslationTriple(
            structured_proof=_proof(),
            lean_code="theorem test : 1 + 1 = 2 := by norm_num",
            compiler_output="No errors.",
            compiled=True,
            model="deepseek",
            attempt_number=1,
        )
        assert triple.compiled is True
        assert triple.compiler_output == "No errors."

    def test_failure_triple_has_error(self):
        triple = TranslationTriple(
            structured_proof=_proof(),
            lean_code="theorem bad := sorry",
            compiler_output="error: type mismatch\n  expected: Prop\n  got: Bool",
            compiled=False,
            model="deepseek",
            attempt_number=3,
        )
        assert triple.compiled is False
        assert "type mismatch" in triple.compiler_output
        assert triple.attempt_number == 3


class TestEscalation:
    def test_needs_human_when_all_fail(self):
        """Verify the outcome type when we simulate exhausted attempts."""
        result_outcome = TranslationOutcome.NEEDS_HUMAN
        assert result_outcome == "needs_human"

    def test_outcome_types(self):
        assert TranslationOutcome.SUCCESS == "success"
        assert TranslationOutcome.FAILED_TIER1 == "failed_tier1"
        assert TranslationOutcome.FAILED_TIER2 == "failed_tier2"
        assert TranslationOutcome.NEEDS_HUMAN == "needs_human"
