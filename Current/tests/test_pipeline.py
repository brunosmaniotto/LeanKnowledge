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
from leanknowledge.backlog import Backlog, BacklogEntry, BacklogStatus
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

        # Def 1.1 should be skipped (exact match), only Thm 1.2 added
        assert pipeline.backlog.get("Def 1.1") is None
        assert pipeline.backlog.get("Thm 1.2") is not None

    def test_ingest_idempotent(self):
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())
        pipeline._ingest(_make_extraction())

        # Same items should not be duplicated
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
    def test_formalize_next_picks_theorem(self):
        """formalize_next skips definitions, picks theorems."""
        pipeline = Pipeline()
        pipeline._ingest(_make_extraction())

        # Only Thm 1.2 should be a candidate (Def 1.1 is a DEFINITION)
        ready_theorems = [
            e for e in pipeline.backlog.ready()
            if e.category == ItemCategory.THEOREM
        ]
        assert len(ready_theorems) == 1
        assert ready_theorems[0].item.id == "Thm 1.2"

    def test_formalize_next_empty_backlog(self):
        pipeline = Pipeline()
        result = pipeline.formalize_next()
        assert result is None

    def test_formalize_next_no_theorems(self):
        """Backlog with only definitions → returns None."""
        pipeline = Pipeline()
        entry = BacklogEntry(
            item=_make_items()[0],  # definition
            category=ItemCategory.DEFINITION,
        )
        pipeline.backlog.add(entry)

        result = pipeline.formalize_next()
        assert result is None

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
        assert "Backlog: 2 items" in status
        assert "ready: 2" in status

    def test_status_empty(self):
        pipeline = Pipeline()
        status = pipeline.status()
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
