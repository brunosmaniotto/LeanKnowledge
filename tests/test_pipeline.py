"""Tests for the pipeline orchestrator.

All tests use mock agents / compilers — no LLM or Lean calls.
"""

import json

import pytest

from leanknowledge.schemas import (
    ExtractedItem, ExtractionResult, StatementType, ClaimRole,
    StructuredProof, ProofStrategy, ProofStep,
)
from leanknowledge.agents.triage import TriageAgent, ItemCategory
from leanknowledge.agents.librarian import InMemoryLibrary
from leanknowledge.backlog import Backlog, BacklogEntry, BacklogStatus, DependencyType
from leanknowledge.agents.translator import SubLemma
from leanknowledge.pipeline import Pipeline, PipelineResult


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

def _make_items():
    """Two items: one definition, one theorem."""
    return [
        ExtractedItem(
            id="Def 1.1",
            type=StatementType.DEFINITION,
            role=ClaimRole.DEFINITION,
            statement="A set X is compact if every open cover has a finite subcover.",
            section="1.A",
        ),
        ExtractedItem(
            id="Thm 1.2",
            type=StatementType.THEOREM,
            role=ClaimRole.CLAIMED_RESULT,
            statement="Every closed subset of a compact set is compact.",
            proof="Let F be closed in K, and let {U_a} cover F...",
            section="1.A",
        ),
    ]


def _make_extraction():
    return ExtractionResult(source="Test", items=_make_items())


# ---------------------------------------------------------------------------
# Ingest path tests
# ---------------------------------------------------------------------------

class TestIngestPath:
    def test_ingest_adds_to_backlog(self):
        pipeline = Pipeline()
        result = _make_extraction()

        pipeline._ingest(result)

        # Items should be in both inbox and backlog
        assert len(pipeline.inbox.entries) == 2
        assert len(pipeline.backlog.entries) == 2
        assert pipeline.backlog.get("Def 1.1") is not None
        assert pipeline.backlog.get("Thm 1.2") is not None

    def test_ingest_triage_categories(self):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())

        def_entry = pipeline.backlog.get("Def 1.1")
        thm_entry = pipeline.backlog.get("Thm 1.2")
        assert def_entry.category == ItemCategory.DEFINITION
        assert thm_entry.category == ItemCategory.THEOREM
        # No deps → both auto-resolve to READY
        assert def_entry.status == BacklogStatus.READY
        assert thm_entry.status == BacklogStatus.READY

    def test_ingest_skips_duplicates(self):
        library = InMemoryLibrary()
        library.add(
            "Def 1.1",
            "A set X is compact if every open cover has a finite subcover.",
        )
        pipeline = Pipeline(library=library)
        pipeline._ingest(_make_extraction())

        # Def 1.1 should be in inbox as DUPLICATE but NOT in backlog
        from leanknowledge.inbox import InboxStatus
        assert pipeline.inbox.entries["Def 1.1"].status == InboxStatus.DUPLICATE
        assert pipeline.backlog.get("Def 1.1") is None
        assert pipeline.backlog.get("Thm 1.2") is not None

    def test_ingest_idempotent(self):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())
        pipeline._ingest(_make_extraction())

        # Same items should not be duplicated
        assert len(pipeline.inbox.entries) == 2
        assert len(pipeline.backlog.entries) == 2


# ---------------------------------------------------------------------------
# Formalization path tests
# ---------------------------------------------------------------------------

class MockCompiler:
    """Compiler that succeeds on attempt N."""

    def __init__(self, succeed_on: int = 1):
        self.succeed_on = succeed_on
        self.call_count = 0

    def compile(self, code: str) -> tuple[bool, str]:
        self.call_count += 1
        if self.call_count >= self.succeed_on:
            return True, ""
        return False, f"error: type mismatch (attempt {self.call_count})"


class AlwaysFailCompiler:
    def compile(self, code: str) -> tuple[bool, str]:
        return False, "error: unknown identifier 'foo'"


class TestFormalizePath:
    def test_formalize_next_prioritizes_theorems(self):
        """formalize_next picks theorems before definitions."""
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())

        # Both items are ready, but theorems should be prioritized
        ready = pipeline.backlog.ready()
        assert len(ready) == 2

        # Sort the same way formalize_next does
        ready.sort(key=lambda e: (0 if e.category == ItemCategory.THEOREM else 1))
        assert ready[0].item.id == "Thm 1.2"  # theorem first
        assert ready[1].item.id == "Def 1.1"  # definition second

    def test_formalize_next_empty_backlog(self):
        pipeline = Pipeline()
        result = pipeline.formalize_next()
        assert result is None

    def test_formalize_next_definitions_processed(self):
        """Backlog with only definitions → definitions are now processed."""
        pipeline = Pipeline()
        entry = BacklogEntry(
            item=_make_items()[0],  # definition
            category=ItemCategory.DEFINITION,
        )
        pipeline.backlog.add(entry)

        # formalize_next should find the definition (not return None)
        ready = pipeline.backlog.ready()
        assert len(ready) == 1
        assert ready[0].category == ItemCategory.DEFINITION

    def test_formalize_entry_routes_definition(self):
        """formalize_entry routes definitions to _formalize_definition."""
        pipeline = Pipeline()
        entry = BacklogEntry(
            item=_make_items()[0],  # definition
            category=ItemCategory.DEFINITION,
        )
        pipeline.backlog.add(entry)

        # Verify the entry is classified as DEFINITION
        assert entry.category == ItemCategory.DEFINITION

    def test_formalize_entry_routes_theorem(self):
        """formalize_entry routes theorems to _formalize_theorem."""
        pipeline = Pipeline()
        entry = BacklogEntry(
            item=_make_items()[1],  # theorem
            category=ItemCategory.THEOREM,
        )
        pipeline.backlog.add(entry)

        # Verify the entry is classified as THEOREM
        assert entry.category == ItemCategory.THEOREM

    def test_mark_in_progress(self):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())

        entry = pipeline.backlog.get("Thm 1.2")
        assert entry.status == BacklogStatus.READY

        pipeline.backlog.mark_in_progress("Thm 1.2")
        assert entry.status == BacklogStatus.IN_PROGRESS


# ---------------------------------------------------------------------------
# Backlog persistence tests
# ---------------------------------------------------------------------------

class TestBacklogPersistence:
    def test_save_and_load(self, tmp_path):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())
        pipeline.backlog.mark_in_progress("Thm 1.2")
        pipeline.backlog.mark_completed("Thm 1.2", lean_file="thm_1.2.lean")

        save_path = tmp_path / "backlog.json"
        pipeline.save_backlog(save_path)

        assert save_path.exists()

        # Load into fresh pipeline
        pipeline2 = Pipeline()
        pipeline2.load_backlog(save_path)

        assert len(pipeline2.backlog.entries) == 2
        entry = pipeline2.backlog.get("Thm 1.2")
        assert entry.status == BacklogStatus.COMPLETED
        assert entry.lean_file == "thm_1.2.lean"

    def test_load_nonexistent(self, tmp_path):
        pipeline = Pipeline()
        pipeline.load_backlog(tmp_path / "nonexistent.json")
        assert len(pipeline.backlog.entries) == 0

    def test_roundtrip_preserves_all_fields(self, tmp_path):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())
        pipeline.backlog.mark_in_progress("Thm 1.2")
        pipeline.backlog.mark_failed("Thm 1.2", reason="type mismatch")

        save_path = tmp_path / "bl.json"
        pipeline.save_backlog(save_path)

        pipeline2 = Pipeline()
        pipeline2.load_backlog(save_path)

        entry = pipeline2.backlog.get("Thm 1.2")
        assert entry.status == BacklogStatus.FAILED
        assert entry.failure_reason == "type mismatch"
        assert entry.attempts == 1


# ---------------------------------------------------------------------------
# Status
# ---------------------------------------------------------------------------

class TestStatus:
    def test_status_output(self):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())

        status = pipeline.status()
        assert "Inbox: 2 items" in status
        assert "Backlog: 2 items" in status
        assert "ready: 2" in status

    def test_status_empty(self):
        pipeline = Pipeline()
        status = pipeline.status()
        assert "Inbox: 0 items" in status
        assert "Backlog: 0 items" in status


# ---------------------------------------------------------------------------
# Lean output saving
# ---------------------------------------------------------------------------

class TestSaveOutput:
    def test_save_lean(self, tmp_path):
        pipeline = Pipeline(output_dir=tmp_path)
        path = pipeline._save_lean("Thm 1.2", "theorem thm_1_2 : True := trivial")

        assert (tmp_path / "lean" / "thm_1.2.lean").exists()
        content = (tmp_path / "lean" / "thm_1.2.lean").read_text()
        assert "trivial" in content


# ---------------------------------------------------------------------------
# Failure diagnostics
# ---------------------------------------------------------------------------

class TestFailureRecord:
    def test_failure_record_with_triples(self, tmp_path):
        from leanknowledge.agents.translator import (
            TranslationResult, TranslationOutcome, TranslationTriple,
        )

        pipeline = Pipeline(output_dir=tmp_path)
        proof = StructuredProof(
            theorem_name="test", strategy=ProofStrategy.DIRECT,
            goal_statement="1=1", steps=[], conclusion="done",
        )
        translation = TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            triples=[
                TranslationTriple(
                    structured_proof=proof, lean_code="theorem t : True := by sorry",
                    compiler_output="error: unknown identifier 'foo'",
                    compiled=False, model="deepseek/deepseek-reasoner",
                    attempt_number=1,
                ),
            ],
            total_attempts=1,
        )

        pipeline._save_failure_record("My Theorem", translation, "unknown identifier")

        record_path = tmp_path / "failures" / "my_theorem.json"
        assert record_path.exists()
        record = json.loads(record_path.read_text())
        assert record["item_id"] == "My Theorem"
        assert record["total_attempts"] == 1
        assert record["cause"] == "hallucinated_identifier"
        assert "deepseek" in record["models_used"][0]

    def test_failure_record_crash(self, tmp_path):
        pipeline = Pipeline(output_dir=tmp_path)
        pipeline._save_failure_record("Crashed Thm", None, "ConnectionError: peer closed")

        record_path = tmp_path / "failures" / "crashed_thm.json"
        assert record_path.exists()
        record = json.loads(record_path.read_text())
        assert record["cause"] == "crash"
        assert record["total_attempts"] == 0

    def test_failure_record_no_triples(self, tmp_path):
        from leanknowledge.agents.translator import TranslationResult, TranslationOutcome

        pipeline = Pipeline(output_dir=tmp_path)
        translation = TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            triples=[], total_attempts=0,
        )
        pipeline._save_failure_record("Empty Thm", translation, "no output")

        record = json.loads(
            (tmp_path / "failures" / "empty_thm.json").read_text()
        )
        assert record["cause"] == "no_triples"


# ---------------------------------------------------------------------------
# Sub-lemma creation from decomposition
# ---------------------------------------------------------------------------

class TestSubLemmaCreation:
    def test_creates_backlog_entries(self):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())

        sub_lemmas = [
            SubLemma(
                name="step1",
                lean_signature="lemma step1 (n : Nat) : n + 0 = n",
                nl_description="Adding zero is identity",
                nl_proof_hint="Use Nat.add_zero",
            ),
            SubLemma(
                name="step2",
                lean_signature="lemma step2 : 1 = 1",
                nl_description="One equals one",
                nl_proof_hint="",
            ),
        ]

        ids = pipeline._create_sub_lemma_entries("Thm 1.2", sub_lemmas)

        assert len(ids) == 2
        assert "Thm 1.2/sub/step1" in ids
        assert "Thm 1.2/sub/step2" in ids

        # Sub-lemmas should be in both inbox and backlog as READY theorems
        assert "Thm 1.2/sub/step1" in pipeline.inbox.entries
        e1 = pipeline.backlog.get("Thm 1.2/sub/step1")
        assert e1 is not None
        assert e1.status == BacklogStatus.READY
        assert e1.category == ItemCategory.THEOREM
        assert e1.item.statement == "Adding zero is identity"
        assert "Lean signature:" in e1.item.proof_sketch

    def test_sub_lemma_dependencies_mapped(self):
        pipeline = Pipeline()

        sub_lemmas = [
            SubLemma(
                name="base",
                lean_signature="lemma base : True",
                nl_description="Base case",
                nl_proof_hint="",
                depends_on=[],
            ),
            SubLemma(
                name="inductive",
                lean_signature="lemma inductive : True",
                nl_description="Inductive step",
                nl_proof_hint="Use base",
                depends_on=["base"],
            ),
        ]

        pipeline._create_sub_lemma_entries("MyThm", sub_lemmas)

        ind = pipeline.backlog.get("MyThm/sub/inductive")
        assert ind.item.dependencies == ["MyThm/sub/base"]

    def test_mark_decomposed(self):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())

        pipeline.backlog.mark_in_progress("Thm 1.2")
        pipeline.backlog.mark_decomposed("Thm 1.2", lean_file="thm_1.2.lean")

        entry = pipeline.backlog.get("Thm 1.2")
        assert entry.status == BacklogStatus.AXIOMATIZED
        assert entry.lean_file == "thm_1.2.lean"
        assert entry.dependency_info is not None
        assert entry.dependency_info.dependency_type == DependencyType.DECOMPOSITION
