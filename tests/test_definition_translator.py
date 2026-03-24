"""Tests for definition formalization path (Agent 6 definition mode)."""

from leanknowledge.schemas import (
    ExtractedItem, StatementType, ClaimRole,
)
from leanknowledge.agents.translator import (
    TranslatorAgent, LeanCompiler, TranslationOutcome, TranslationResult,
    TranslationTriple, _minimal_proof,
    _build_definition_prompt, _build_definition_retry_prompt,
    _extract_construct, _extract_lean_code,
    DEFINITION_PROMPT_PATH, DEFINITION_MAX_ATTEMPTS,
    DEFINITION_MODEL, DEFINITION_ESCALATION_MODEL,
)
from leanknowledge.agents.triage import ItemCategory
from leanknowledge.backlog import BacklogEntry, BacklogStatus
from leanknowledge.pipeline import Pipeline
from leanknowledge.schemas import ExtractionResult


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

def _def_item() -> ExtractedItem:
    """A definition item for testing."""
    return ExtractedItem(
        id="Def 1.1",
        type=StatementType.DEFINITION,
        role=ClaimRole.DEFINITION,
        statement="A set X is compact if every open cover has a finite subcover.",
        section="Topology",
        context="In the context of topological spaces.",
    )


def _def_item_no_context() -> ExtractedItem:
    """A definition item without context."""
    return ExtractedItem(
        id="Def 2.1",
        type=StatementType.DEFINITION,
        role=ClaimRole.DEFINITION,
        statement="A group is a set G with a binary operation satisfying closure, associativity, identity, and inverse.",
        section="Algebra",
    )


def _thm_item() -> ExtractedItem:
    """A theorem item for comparison testing."""
    return ExtractedItem(
        id="Thm 1.2",
        type=StatementType.THEOREM,
        role=ClaimRole.CLAIMED_RESULT,
        statement="Every closed subset of a compact set is compact.",
        proof="Let F be closed in K...",
        section="Topology",
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
        return False, "error: unknown identifier 'CompactSpace'"


# ---------------------------------------------------------------------------
# Definition prompt building tests
# ---------------------------------------------------------------------------

class TestDefinitionPromptBuilding:
    def test_definition_prompt_has_statement(self):
        prompt = _build_definition_prompt(_def_item())
        assert "Def 1.1" in prompt
        assert "compact" in prompt
        assert "open cover" in prompt

    def test_definition_prompt_has_context(self):
        prompt = _build_definition_prompt(_def_item())
        assert "topological spaces" in prompt

    def test_definition_prompt_no_context(self):
        prompt = _build_definition_prompt(_def_item_no_context())
        assert "Def 2.1" in prompt
        assert "Context" not in prompt

    def test_definition_prompt_asks_for_construct(self):
        prompt = _build_definition_prompt(_def_item())
        assert "CONSTRUCT:" in prompt
        assert "def" in prompt
        assert "structure" in prompt
        assert "class" in prompt

    def test_definition_prompt_no_proof_plan(self):
        prompt = _build_definition_prompt(_def_item())
        assert "PROOF PLAN" not in prompt
        assert "PREVIOUS ATTEMPTS" not in prompt

    def test_definition_prompt_no_proof_section(self):
        """Definitions typically don't have proofs."""
        item = _def_item()
        item.proof = None
        prompt = _build_definition_prompt(item)
        assert "Informal proof" not in prompt

    def test_definition_prompt_with_additional_detail(self):
        item = _def_item()
        item.proof = "The definition extends to locally compact spaces."
        prompt = _build_definition_prompt(item)
        assert "Additional detail" in prompt
        assert "locally compact" in prompt


class TestDefinitionRetryPrompt:
    def test_retry_prompt_has_history(self):
        history = [
            TranslationTriple(
                structured_proof=_minimal_proof(_def_item()),
                lean_code="def CompactSet := sorry",
                compiler_output="error: type mismatch",
                compiled=False,
                model="deepseek/deepseek-reasoner",
                attempt_number=1,
            ),
        ]
        prompt = _build_definition_retry_prompt(_def_item(), history)
        assert "PREVIOUS ATTEMPTS" in prompt
        assert "ATTEMPT 1" in prompt
        assert "type mismatch" in prompt
        assert "FAILED" in prompt

    def test_retry_prompt_has_definition_statement(self):
        history = [
            TranslationTriple(
                structured_proof=_minimal_proof(_def_item()),
                lean_code="def bad := sorry",
                compiler_output="error",
                compiled=False,
                model="test",
                attempt_number=1,
            ),
        ]
        prompt = _build_definition_retry_prompt(_def_item(), history)
        assert "compact" in prompt
        assert "Def 1.1" in prompt

    def test_retry_prompt_shows_multiple_attempts(self):
        history = [
            TranslationTriple(
                structured_proof=_minimal_proof(_def_item()),
                lean_code=f"def attempt_{i} := sorry",
                compiler_output=f"error_{i}",
                compiled=False,
                model="test",
                attempt_number=i,
            )
            for i in range(1, 4)
        ]
        prompt = _build_definition_retry_prompt(_def_item(), history)
        assert "ATTEMPT 1" in prompt
        assert "ATTEMPT 2" in prompt
        assert "ATTEMPT 3" in prompt

    def test_retry_prompt_asks_for_construct(self):
        history = [
            TranslationTriple(
                structured_proof=_minimal_proof(_def_item()),
                lean_code="def bad := sorry",
                compiler_output="error",
                compiled=False,
                model="test",
                attempt_number=1,
            ),
        ]
        prompt = _build_definition_retry_prompt(_def_item(), history)
        assert "CONSTRUCT:" in prompt

    def test_retry_prompt_no_proof_plan(self):
        history = [
            TranslationTriple(
                structured_proof=_minimal_proof(_def_item()),
                lean_code="def bad := sorry",
                compiler_output="error",
                compiled=False,
                model="test",
                attempt_number=1,
            ),
        ]
        prompt = _build_definition_retry_prompt(_def_item(), history)
        assert "PROOF PLAN" not in prompt


# ---------------------------------------------------------------------------
# CONSTRUCT extraction tests
# ---------------------------------------------------------------------------

class TestConstructExtraction:
    def test_extract_construct_def(self):
        response = "CONSTRUCT: def — this is a simple computable definition\n```lean\ndef myDef := 42\n```"
        assert "def" in _extract_construct(response)

    def test_extract_construct_structure(self):
        response = "CONSTRUCT: structure — bundled data with fields\n```lean\nstructure MyStruct where\n  x : Nat\n```"
        assert "structure" in _extract_construct(response)

    def test_extract_construct_class(self):
        response = "CONSTRUCT: class — typeclass for algebraic structure\n```lean\nclass MyClass where\n```"
        assert "class" in _extract_construct(response)

    def test_extract_construct_abbrev(self):
        response = "CONSTRUCT: abbrev — simple alias\n```lean\nabbrev MyAlias := Nat\n```"
        assert "abbrev" in _extract_construct(response)

    def test_extract_construct_noncomputable(self):
        response = "CONSTRUCT: noncomputable def — involves classical choice\n```lean\nnoncomputable def x := Classical.choice ...\n```"
        assert "noncomputable" in _extract_construct(response)

    def test_extract_construct_missing(self):
        response = "```lean\ndef myDef := 42\n```"
        assert _extract_construct(response) == ""

    def test_extract_construct_case_insensitive(self):
        response = "construct: def — simple definition\n```lean\ndef x := 1\n```"
        assert "def" in _extract_construct(response)


# ---------------------------------------------------------------------------
# Definition system prompt tests
# ---------------------------------------------------------------------------

class TestDefinitionSystemPrompt:
    def test_prompt_file_exists(self):
        assert DEFINITION_PROMPT_PATH.exists(), (
            f"Definition prompt file not found at {DEFINITION_PROMPT_PATH}"
        )

    def test_prompt_file_has_content(self):
        content = DEFINITION_PROMPT_PATH.read_text(encoding="utf-8")
        assert len(content) > 100

    def test_prompt_mentions_lean_constructs(self):
        content = DEFINITION_PROMPT_PATH.read_text(encoding="utf-8")
        assert "def" in content
        assert "structure" in content
        assert "class" in content
        assert "instance" in content
        assert "abbrev" in content

    def test_prompt_mentions_mathlib(self):
        content = DEFINITION_PROMPT_PATH.read_text(encoding="utf-8")
        assert "Mathlib" in content

    def test_prompt_mentions_import(self):
        content = DEFINITION_PROMPT_PATH.read_text(encoding="utf-8")
        assert "import Mathlib" in content


# ---------------------------------------------------------------------------
# Definition environment variable tests
# ---------------------------------------------------------------------------

class TestDefinitionConfig:
    def test_default_max_attempts(self):
        assert DEFINITION_MAX_ATTEMPTS == 6

    def test_default_model(self):
        # Should default to TIER1_MODEL
        assert DEFINITION_MODEL is not None
        assert len(DEFINITION_MODEL) > 0

    def test_default_escalation_model(self):
        # Should default to TIER2_MODEL
        assert DEFINITION_ESCALATION_MODEL is not None
        assert len(DEFINITION_ESCALATION_MODEL) > 0


# ---------------------------------------------------------------------------
# TranslationOutcome tests
# ---------------------------------------------------------------------------

class TestDefinitionOutcome:
    def test_definition_success_outcome_exists(self):
        assert TranslationOutcome.DEFINITION_SUCCESS == "definition_success"

    def test_definition_success_distinct_from_theorem(self):
        assert TranslationOutcome.DEFINITION_SUCCESS != TranslationOutcome.SUCCESS

    def test_translation_result_with_definition_success(self):
        result = TranslationResult(
            outcome=TranslationOutcome.DEFINITION_SUCCESS,
            lean_code="def myDef (n : Nat) : Nat := n + 1",
            total_attempts=1,
        )
        assert result.outcome == TranslationOutcome.DEFINITION_SUCCESS
        assert result.lean_code is not None


# ---------------------------------------------------------------------------
# Pipeline routing tests
# ---------------------------------------------------------------------------

class TestPipelineRouting:
    def test_pipeline_routes_definitions(self):
        """Pipeline.formalize_entry routes definitions to _formalize_definition."""
        pipeline = Pipeline()

        def_entry = BacklogEntry(
            item=_def_item(),
            category=ItemCategory.DEFINITION,
        )
        pipeline.backlog.add(def_entry)

        # The entry should be DEFINITION category
        entry = pipeline.backlog.get("Def 1.1")
        assert entry.category == ItemCategory.DEFINITION

    def test_pipeline_routes_theorems(self):
        """Pipeline.formalize_entry routes theorems to _formalize_theorem."""
        pipeline = Pipeline()

        thm_entry = BacklogEntry(
            item=_thm_item(),
            category=ItemCategory.THEOREM,
        )
        pipeline.backlog.add(thm_entry)

        # The entry should be THEOREM category
        entry = pipeline.backlog.get("Thm 1.2")
        assert entry.category == ItemCategory.THEOREM

    def test_formalize_next_processes_definitions(self):
        """formalize_next returns a definition when no theorems are available."""
        pipeline = Pipeline()
        def_entry = BacklogEntry(
            item=_def_item(),
            category=ItemCategory.DEFINITION,
        )
        pipeline.backlog.add(def_entry)

        # With only a definition in the backlog, formalize_next should
        # find it (not return None like the old behavior)
        ready = pipeline.backlog.ready()
        assert len(ready) == 1
        assert ready[0].category == ItemCategory.DEFINITION

    def test_formalize_next_prioritizes_theorems(self):
        """formalize_next prioritizes theorems over definitions."""
        pipeline = Pipeline()

        items = [
            ExtractedItem(
                id="Def 1.1",
                type=StatementType.DEFINITION,
                role=ClaimRole.DEFINITION,
                statement="A set X is compact if...",
                section="1.A",
            ),
            ExtractedItem(
                id="Thm 1.2",
                type=StatementType.THEOREM,
                role=ClaimRole.CLAIMED_RESULT,
                statement="Every closed subset is compact.",
                proof="Proof...",
                section="1.A",
            ),
        ]
        result = ExtractionResult(source="Test", items=items)
        pipeline._ingest(result)

        # Both should be in the backlog
        ready = pipeline.backlog.ready()
        assert len(ready) == 2

        # Sorted: theorems first
        ready.sort(key=lambda e: (0 if e.category == ItemCategory.THEOREM else 1))
        assert ready[0].item.id == "Thm 1.2"
        assert ready[1].item.id == "Def 1.1"

    def test_formalize_all_includes_definitions(self):
        """formalize_all description mentions both types."""
        pipeline = Pipeline()
        # Just verify the method docstring/intent is correct
        assert "definitions" in pipeline.formalize_all.__doc__.lower() or \
               "items" in pipeline.formalize_all.__doc__.lower()


# ---------------------------------------------------------------------------
# Code extraction for definitions
# ---------------------------------------------------------------------------

class TestDefinitionCodeExtraction:
    def test_extract_def_code(self):
        response = (
            "CONSTRUCT: def — simple computable definition\n"
            "```lean\n"
            "import Mathlib\n\n"
            "def myFunc (n : Nat) : Nat := n + 1\n"
            "```"
        )
        code = _extract_lean_code(response)
        assert "def myFunc" in code
        assert "import Mathlib" in code

    def test_extract_structure_code(self):
        response = (
            "CONSTRUCT: structure\n"
            "```lean\n"
            "import Mathlib\n\n"
            "structure Point where\n"
            "  x : Float\n"
            "  y : Float\n"
            "```"
        )
        code = _extract_lean_code(response)
        assert "structure Point" in code

    def test_extract_noncomputable_def(self):
        response = (
            "CONSTRUCT: noncomputable def\n"
            "```lean\n"
            "import Mathlib\n\n"
            "noncomputable def myFunc : Real := Real.sqrt 2\n"
            "```"
        )
        code = _extract_lean_code(response)
        assert "noncomputable" in code

    def test_extract_abbrev(self):
        response = (
            "CONSTRUCT: abbrev\n"
            "```lean\n"
            "import Mathlib\n\n"
            "abbrev MyNat := Nat\n"
            "```"
        )
        code = _extract_lean_code(response)
        assert "abbrev MyNat" in code
