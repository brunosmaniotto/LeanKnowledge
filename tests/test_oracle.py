"""Tests for the Oracle tier — last-resort escalation for hard theorems."""

import os
from contextlib import contextmanager
from pathlib import Path
from unittest.mock import patch, MagicMock

from leanknowledge.schemas import (
    StructuredProof, ProofStrategy, ProofStep,
    ExtractedItem, StatementType, ClaimRole,
)
from leanknowledge.agents.translator import (
    TranslatorAgent, LeanCompiler, TranslationOutcome, TranslationResult,
    TranslationTriple, _minimal_proof,
    _build_oracle_prompt, _extract_oracle_analysis, _ORACLE_SYSTEM,
    ORACLE_ENABLED, ORACLE_MODEL, ORACLE_MAX_ATTEMPTS,
)


def _mock_prompt_path():
    """Create a MagicMock Path that returns empty string for read_text."""
    mp = MagicMock(spec=Path)
    mp.exists.return_value = False
    mp.read_text.return_value = ""
    return mp


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


def _item() -> ExtractedItem:
    return ExtractedItem(
        id="Thm 1.1",
        type=StatementType.THEOREM,
        role=ClaimRole.CLAIMED_RESULT,
        statement="1 + 1 = 2",
        proof="By computation.",
        section="1.A",
    )


def _make_failure_triples(count: int) -> list[TranslationTriple]:
    """Generate a list of failed TranslationTriples for testing."""
    triples = []
    models = ["deepseek/deepseek-reasoner", "gemini/gemini-2.5-pro"]
    errors = [
        "error: type mismatch\n  expected: Prop\n  got: Bool",
        "error: Unknown identifier `Foo.bar`",
        "error: unsolved goals\nn : Nat\n|- n = n + 1",
        "error: function expected",
    ]
    for i in range(1, count + 1):
        triples.append(TranslationTriple(
            structured_proof=_proof(),
            lean_code=f"theorem test_thm : 1 + 1 = 2 := by sorry -- attempt {i}",
            compiler_output=errors[(i - 1) % len(errors)],
            compiled=False,
            model=models[(i - 1) % len(models)],
            attempt_number=i,
            reasoning=f"Tried approach {i}: used {'simp' if i % 2 == 0 else 'omega'}",
        ))
    return triples


class AlwaysFailCompiler(LeanCompiler):
    """Compiler that always fails."""
    def __init__(self):
        self.call_count = 0

    def compile(self, code: str) -> tuple[bool, str]:
        self.call_count += 1
        return False, "error: unknown identifier 'foo'"


class SucceedOnNthCompiler(LeanCompiler):
    """Compiler that succeeds on the Nth call."""
    def __init__(self, succeed_on: int):
        self.succeed_on = succeed_on
        self.call_count = 0

    def compile(self, code: str) -> tuple[bool, str]:
        self.call_count += 1
        if self.call_count >= self.succeed_on:
            return True, "No errors."
        return False, f"error: type mismatch (attempt {self.call_count})"


# ---------------------------------------------------------------------------
# Oracle prompt building
# ---------------------------------------------------------------------------

class TestOraclePromptBuilding:
    def test_oracle_prompt_has_theorem(self):
        triples = _make_failure_triples(3)
        prompt = _build_oracle_prompt(_item(), triples)
        assert "Thm 1.1" in prompt
        assert "1 + 1 = 2" in prompt
        assert "By computation" in prompt

    def test_oracle_prompt_has_all_prior_attempts(self):
        triples = _make_failure_triples(5)
        prompt = _build_oracle_prompt(_item(), triples)
        assert "ATTEMPT 1" in prompt
        assert "ATTEMPT 2" in prompt
        assert "ATTEMPT 3" in prompt
        assert "ATTEMPT 4" in prompt
        assert "ATTEMPT 5" in prompt

    def test_oracle_prompt_has_failure_analysis_section(self):
        triples = _make_failure_triples(3)
        prompt = _build_oracle_prompt(_item(), triples)
        assert "FAILURE ANALYSIS REQUEST" in prompt
        assert "COMMON ERROR PATTERN" in prompt
        assert "ROOT CAUSE" in prompt
        assert "ANALYSIS:" in prompt

    def test_oracle_prompt_shows_full_code_for_last_3(self):
        triples = _make_failure_triples(6)
        prompt = _build_oracle_prompt(_item(), triples)
        # Last 3 attempts should have full code
        assert "sorry -- attempt 4" in prompt
        assert "sorry -- attempt 5" in prompt
        assert "sorry -- attempt 6" in prompt
        # Older attempts may be compact (approach + error only)

    def test_oracle_prompt_compact_for_old_attempts(self):
        triples = _make_failure_triples(10)
        prompt = _build_oracle_prompt(_item(), triples)
        # Old attempts (before the last 3) should show approach, not full code
        # Last 3 are attempts 8, 9, 10 which get full code
        # Attempts 1-7 should be compact
        assert "ALL 10 PRIOR ATTEMPTS" in prompt

    def test_oracle_prompt_marks_oracle_mode(self):
        triples = _make_failure_triples(3)
        prompt = _build_oracle_prompt(_item(), triples)
        assert "ORACLE MODE" in prompt

    def test_oracle_prompt_no_proof(self):
        item = _item()
        item.proof = None
        triples = _make_failure_triples(2)
        prompt = _build_oracle_prompt(item, triples)
        assert "Thm 1.1" in prompt
        assert "Informal proof" not in prompt

    def test_oracle_prompt_with_proof_sketch(self):
        item = _item()
        item.proof = None
        item.proof_sketch = "Sketch of proof"
        triples = _make_failure_triples(1)
        prompt = _build_oracle_prompt(item, triples)
        assert "Sketch of proof" in prompt


# ---------------------------------------------------------------------------
# Oracle system prompt
# ---------------------------------------------------------------------------

class TestOracleSystemPrompt:
    def test_system_prompt_mentions_last_resort(self):
        assert "LAST RESORT" in _ORACLE_SYSTEM

    def test_system_prompt_mentions_analyze(self):
        assert "ANALYZE" in _ORACLE_SYSTEM

    def test_system_prompt_mentions_different_approach(self):
        assert "DIFFERENT approach" in _ORACLE_SYSTEM

    def test_system_prompt_has_lean_conventions(self):
        assert "import Mathlib" in _ORACLE_SYSTEM
        assert "norm_num" in _ORACLE_SYSTEM
        assert "simp" in _ORACLE_SYSTEM

    def test_system_prompt_mentions_fundamentally_different(self):
        assert "fundamentally different" in _ORACLE_SYSTEM.lower()


# ---------------------------------------------------------------------------
# Analysis extraction
# ---------------------------------------------------------------------------

class TestOracleAnalysisExtraction:
    def test_extract_analysis_basic(self):
        response = (
            "ANALYSIS: All attempts used simp which is insufficient.\n"
            "The root cause is a type mismatch between Nat and Int.\n"
            "APPROACH: Use omega instead.\n"
            "```lean\ntheorem x : True := trivial\n```"
        )
        analysis = _extract_oracle_analysis(response)
        assert "All attempts used simp" in analysis
        assert "type mismatch" in analysis
        assert "APPROACH" not in analysis

    def test_extract_analysis_multiline(self):
        response = (
            "ANALYSIS:\n"
            "1. Common error: type mismatch\n"
            "2. Root cause: Nat vs Int\n"
            "3. Not tried: omega\n"
            "APPROACH: Use omega.\n"
            "```lean\ntheorem x : True := trivial\n```"
        )
        analysis = _extract_oracle_analysis(response)
        assert "Common error" in analysis
        assert "Root cause" in analysis
        assert "Not tried" in analysis

    def test_extract_analysis_stops_at_code_fence(self):
        response = (
            "ANALYSIS: The issue is type coercion.\n"
            "```lean\ntheorem x : True := trivial\n```"
        )
        analysis = _extract_oracle_analysis(response)
        assert "type coercion" in analysis
        assert "```" not in analysis

    def test_extract_analysis_missing(self):
        response = (
            "APPROACH: Use omega.\n"
            "```lean\ntheorem x : True := trivial\n```"
        )
        analysis = _extract_oracle_analysis(response)
        assert analysis == ""

    def test_extract_analysis_same_line(self):
        response = (
            "ANALYSIS: Short analysis here.\n"
            "APPROACH: Try omega.\n"
        )
        analysis = _extract_oracle_analysis(response)
        assert analysis == "Short analysis here."


# ---------------------------------------------------------------------------
# Oracle configuration
# ---------------------------------------------------------------------------

class TestOracleConfiguration:
    def test_oracle_disabled_by_default(self):
        assert ORACLE_ENABLED is False

    def test_oracle_default_model(self):
        assert ORACLE_MODEL == "anthropic/claude-sonnet-4-20250514"

    def test_oracle_default_attempts(self):
        assert ORACLE_MAX_ATTEMPTS == 5

    def test_outcome_has_oracle_success(self):
        assert TranslationOutcome.ORACLE_SUCCESS == "oracle_success"

    def test_translation_result_has_oracle_analysis_field(self):
        result = TranslationResult(
            outcome=TranslationOutcome.ORACLE_SUCCESS,
            lean_code="theorem x : True := trivial",
            total_attempts=17,
            oracle_analysis="The root cause was type mismatch.",
        )
        assert result.oracle_analysis == "The root cause was type mismatch."

    def test_translation_result_oracle_analysis_defaults_none(self):
        result = TranslationResult(
            outcome=TranslationOutcome.SUCCESS,
            lean_code="theorem x : True := trivial",
            total_attempts=1,
        )
        assert result.oracle_analysis is None


# ---------------------------------------------------------------------------
# Oracle integration (with mocked LLM)
# ---------------------------------------------------------------------------

class TestOracleIntegration:
    """Tests that verify oracle wiring in translate/translate_unstructured.

    All tests mock PROMPT_PATH to avoid filesystem encoding issues on Windows.
    """

    # Common patches needed for all integration tests
    _COMMON_PATCHES = {
        "leanknowledge.agents.translator.PROMPT_PATH": _mock_prompt_path(),
        "leanknowledge.agents.translator.DECOMPOSER_PROMPT_PATH": _mock_prompt_path(),
        "leanknowledge.agents.translator.CATEGORY_PROMPTS_DIR": _mock_prompt_path(),
    }

    def test_oracle_disabled_returns_needs_human(self):
        """When oracle is disabled, all-tiers-exhausted returns NEEDS_HUMAN."""
        compiler = AlwaysFailCompiler()
        agent = TranslatorAgent(compiler)

        with patch("leanknowledge.agents.translator.complete") as mock_complete, \
             patch("leanknowledge.agents.translator.complete_json") as mock_json, \
             patch("leanknowledge.agents.translator.ORACLE_ENABLED", False), \
             patch("leanknowledge.agents.translator.TIER3_ENABLED", False), \
             patch("leanknowledge.agents.translator.PROMPT_PATH", _mock_prompt_path()), \
             patch("leanknowledge.agents.translator.DECOMPOSER_PROMPT_PATH", _mock_prompt_path()):
            mock_complete.return_value = (
                "APPROACH: Use norm_num.\n"
                "```lean\ntheorem test_thm : 1 + 1 = 2 := by norm_num\n```"
            )
            result = agent.translate_unstructured(_item())
            assert result.outcome == TranslationOutcome.NEEDS_HUMAN

    def test_oracle_enabled_calls_oracle_after_standard_tiers(self):
        """When oracle is enabled, it is called after standard tiers fail."""
        compiler = AlwaysFailCompiler()
        agent = TranslatorAgent(compiler)

        call_count = {"value": 0}

        def fake_complete(model, prompt, system="", max_tokens=8192,
                          temperature=0.0):
            call_count["value"] += 1
            return (
                "ANALYSIS: All prior attempts failed due to type mismatch.\n"
                "APPROACH: Use norm_num.\n"
                "```lean\ntheorem test_thm : 1 + 1 = 2 := by norm_num\n```"
            )

        with patch("leanknowledge.agents.translator.complete", side_effect=fake_complete), \
             patch("leanknowledge.agents.translator.complete_json") as mock_json, \
             patch("leanknowledge.agents.translator.ORACLE_ENABLED", True), \
             patch("leanknowledge.agents.translator.TIER3_ENABLED", False), \
             patch("leanknowledge.agents.translator.ORACLE_MAX_ATTEMPTS", 2), \
             patch("leanknowledge.agents.translator.PROMPT_PATH", _mock_prompt_path()), \
             patch("leanknowledge.agents.translator.DECOMPOSER_PROMPT_PATH", _mock_prompt_path()):
            result = agent.translate_unstructured(_item())
            # Oracle was called (NEEDS_HUMAN because compiler always fails)
            assert result.outcome == TranslationOutcome.NEEDS_HUMAN
            # translate_unstructured runs: Tier 1 (7) + Tier 2 (5) = 12 standard
            # Oracle: 2 additional attempts = 14 total
            assert result.total_attempts == 14

    def test_oracle_success_returns_oracle_success_outcome(self):
        """When oracle succeeds, outcome is ORACLE_SUCCESS."""
        # Compiler succeeds on the 17th call (after 16 standard failures)
        compiler = SucceedOnNthCompiler(succeed_on=17)
        agent = TranslatorAgent(compiler)

        def fake_complete(model, prompt, system="", max_tokens=8192,
                          temperature=0.0):
            return (
                "ANALYSIS: Type mismatch was the root cause.\n"
                "APPROACH: Cast to Int first.\n"
                "```lean\ntheorem test_thm : 1 + 1 = 2 := by norm_num\n```"
            )

        with patch("leanknowledge.agents.translator.complete", side_effect=fake_complete), \
             patch("leanknowledge.agents.translator.complete_json") as mock_json, \
             patch("leanknowledge.agents.translator.ORACLE_ENABLED", True), \
             patch("leanknowledge.agents.translator.TIER3_ENABLED", False), \
             patch("leanknowledge.agents.translator.PROMPT_PATH", _mock_prompt_path()), \
             patch("leanknowledge.agents.translator.DECOMPOSER_PROMPT_PATH", _mock_prompt_path()):
            result = agent.translate_unstructured(_item())
            assert result.outcome == TranslationOutcome.ORACLE_SUCCESS
            assert result.oracle_analysis is not None
            assert "Type mismatch" in result.oracle_analysis
            assert result.lean_code is not None

    def test_oracle_carries_all_prior_triples(self):
        """Oracle receives all prior triples from standard tiers."""
        compiler = AlwaysFailCompiler()
        agent = TranslatorAgent(compiler)

        oracle_prompts = []

        def fake_complete(model, prompt, system="", max_tokens=8192,
                          temperature=0.0):
            if "ORACLE MODE" in prompt:
                oracle_prompts.append(prompt)
            return (
                "APPROACH: Use omega.\n"
                "```lean\ntheorem test_thm : 1 + 1 = 2 := by omega\n```"
            )

        with patch("leanknowledge.agents.translator.complete", side_effect=fake_complete), \
             patch("leanknowledge.agents.translator.complete_json") as mock_json, \
             patch("leanknowledge.agents.translator.ORACLE_ENABLED", True), \
             patch("leanknowledge.agents.translator.TIER3_ENABLED", False), \
             patch("leanknowledge.agents.translator.ORACLE_MAX_ATTEMPTS", 1), \
             patch("leanknowledge.agents.translator.PROMPT_PATH", _mock_prompt_path()), \
             patch("leanknowledge.agents.translator.DECOMPOSER_PROMPT_PATH", _mock_prompt_path()):
            result = agent.translate_unstructured(_item())
            # The oracle prompt should mention prior attempts
            assert len(oracle_prompts) >= 1
            oracle_prompt = oracle_prompts[0]
            assert "ORACLE MODE" in oracle_prompt
            assert "PRIOR ATTEMPTS" in oracle_prompt

    def test_oracle_not_called_when_standard_succeeds(self):
        """Oracle is never called if standard tiers succeed."""
        # Compiler succeeds on 1st call
        compiler = SucceedOnNthCompiler(succeed_on=1)
        agent = TranslatorAgent(compiler)

        def fake_complete(model, prompt, system="", max_tokens=8192,
                          temperature=0.0):
            return (
                "APPROACH: Use norm_num.\n"
                "```lean\ntheorem test_thm : 1 + 1 = 2 := by norm_num\n```"
            )

        with patch("leanknowledge.agents.translator.complete", side_effect=fake_complete), \
             patch("leanknowledge.agents.translator.ORACLE_ENABLED", True), \
             patch("leanknowledge.agents.translator.TIER3_ENABLED", False), \
             patch("leanknowledge.agents.translator.PROMPT_PATH", _mock_prompt_path()), \
             patch("leanknowledge.agents.translator.DECOMPOSER_PROMPT_PATH", _mock_prompt_path()):
            result = agent.translate_unstructured(_item())
            assert result.outcome == TranslationOutcome.SUCCESS
            # Should succeed in direct phase, no oracle needed
            assert result.total_attempts == 1
            assert result.oracle_analysis is None

    def test_oracle_in_translate_guided_mode(self):
        """Oracle also works in translate() (guided mode with structured proof)."""
        # Compiler succeeds on call 13 (after 12 standard failures in guided only: 7 + 5)
        compiler = SucceedOnNthCompiler(succeed_on=13)
        agent = TranslatorAgent(compiler)

        def fake_complete(model, prompt, system="", max_tokens=8192,
                          temperature=0.0):
            return (
                "ANALYSIS: Root cause identified.\n"
                "APPROACH: Different strategy.\n"
                "```lean\ntheorem test_thm : 1 + 1 = 2 := by norm_num\n```"
            )

        with patch("leanknowledge.agents.translator.complete", side_effect=fake_complete), \
             patch("leanknowledge.agents.translator.complete_json") as mock_json, \
             patch("leanknowledge.agents.translator.ORACLE_ENABLED", True), \
             patch("leanknowledge.agents.translator.TIER3_ENABLED", False), \
             patch("leanknowledge.agents.translator.PROMPT_PATH", _mock_prompt_path()), \
             patch("leanknowledge.agents.translator.DECOMPOSER_PROMPT_PATH", _mock_prompt_path()):
            # translate() needs an item for oracle to work
            result = agent.translate(_proof(), item=_item())
            assert result.outcome == TranslationOutcome.ORACLE_SUCCESS
            assert result.oracle_analysis is not None

    def test_oracle_translate_no_item_skips_oracle(self):
        """translate() without item cannot call oracle (needs item for prompt)."""
        compiler = AlwaysFailCompiler()
        agent = TranslatorAgent(compiler)

        def fake_complete(model, prompt, system="", max_tokens=8192,
                          temperature=0.0):
            return (
                "APPROACH: Use omega.\n"
                "```lean\ntheorem test_thm : 1 + 1 = 2 := by omega\n```"
            )

        with patch("leanknowledge.agents.translator.complete", side_effect=fake_complete), \
             patch("leanknowledge.agents.translator.complete_json") as mock_json, \
             patch("leanknowledge.agents.translator.ORACLE_ENABLED", True), \
             patch("leanknowledge.agents.translator.TIER3_ENABLED", False), \
             patch("leanknowledge.agents.translator.PROMPT_PATH", _mock_prompt_path()), \
             patch("leanknowledge.agents.translator.DECOMPOSER_PROMPT_PATH", _mock_prompt_path()):
            # translate() without item= should not invoke oracle
            result = agent.translate(_proof())
            assert result.outcome == TranslationOutcome.NEEDS_HUMAN
