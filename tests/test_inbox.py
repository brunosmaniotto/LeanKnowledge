"""Tests for the persistent Inbox module."""

import json

import pytest

from leanknowledge.schemas import ExtractedItem, ExtractionResult, StatementType, ClaimRole
from leanknowledge.agents.triage import TriageAgent, ItemCategory
from leanknowledge.agents.librarian import LibrarianAgent, InMemoryLibrary
from leanknowledge.inbox import Inbox, InboxEntry, InboxStatus, InboxOrigin
from leanknowledge.pipeline import Pipeline


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _item(
    id: str,
    statement: str = "test statement",
    type: StatementType = StatementType.THEOREM,
) -> ExtractedItem:
    return ExtractedItem(
        id=id, type=type, role=ClaimRole.CLAIMED_RESULT,
        statement=statement, section="1.A", labeled=True,
    )


# ---------------------------------------------------------------------------
# Basic operations
# ---------------------------------------------------------------------------

class TestInboxBasic:
    def test_add_and_retrieve(self):
        inbox = Inbox()
        item = _item("Thm_1")
        entry = inbox.add(item, ItemCategory.THEOREM, InboxOrigin.EXTRACTION)

        assert entry.item.id == "Thm_1"
        assert entry.category == ItemCategory.THEOREM
        assert entry.origin == InboxOrigin.EXTRACTION
        assert entry.status == InboxStatus.NEW
        assert "Thm_1" in inbox.entries

    def test_duplicate_skipped_by_id(self):
        inbox = Inbox()
        item = _item("Thm_1")
        entry1 = inbox.add(item, ItemCategory.THEOREM, InboxOrigin.EXTRACTION)
        entry2 = inbox.add(item, ItemCategory.THEOREM, InboxOrigin.EXTRACTION)

        assert entry1 is entry2
        assert len(inbox.entries) == 1

    def test_extraction_origin(self):
        inbox = Inbox()
        entry = inbox.add(_item("E1"), ItemCategory.THEOREM, InboxOrigin.EXTRACTION)
        assert entry.origin == InboxOrigin.EXTRACTION

    def test_axiom_stub_origin(self):
        inbox = Inbox()
        entry = inbox.add(
            _item("A1"), ItemCategory.THEOREM,
            InboxOrigin.AXIOM_STUB, created_during="parent_thm",
        )
        assert entry.origin == InboxOrigin.AXIOM_STUB
        assert entry.created_during == "parent_thm"

    def test_decomposition_origin(self):
        inbox = Inbox()
        entry = inbox.add(_item("D1"), ItemCategory.THEOREM, InboxOrigin.DECOMPOSITION)
        assert entry.origin == InboxOrigin.DECOMPOSITION

    def test_stats(self):
        inbox = Inbox()
        inbox.add(_item("A"), ItemCategory.THEOREM, InboxOrigin.EXTRACTION)
        inbox.add(_item("B"), ItemCategory.DEFINITION, InboxOrigin.EXTRACTION)

        stats = inbox.stats
        assert stats == {"new": 2}


# ---------------------------------------------------------------------------
# Filters
# ---------------------------------------------------------------------------

class TestInboxFilters:
    def test_new_entries(self):
        inbox = Inbox()
        inbox.add(_item("A"), ItemCategory.THEOREM, InboxOrigin.EXTRACTION)
        inbox.add(_item("B"), ItemCategory.THEOREM, InboxOrigin.EXTRACTION)

        assert len(inbox.new_entries()) == 2

    def test_promoted_filter(self):
        inbox = Inbox()
        inbox.add(_item("A"), ItemCategory.THEOREM, InboxOrigin.EXTRACTION)
        inbox.entries["A"].status = InboxStatus.PROMOTED

        assert len(inbox.promoted()) == 1
        assert len(inbox.new_entries()) == 0

    def test_duplicates_filter(self):
        inbox = Inbox()
        inbox.add(_item("A"), ItemCategory.THEOREM, InboxOrigin.EXTRACTION)
        inbox.entries["A"].status = InboxStatus.DUPLICATE

        assert len(inbox.duplicates()) == 1
        assert len(inbox.new_entries()) == 0


# ---------------------------------------------------------------------------
# Persistence
# ---------------------------------------------------------------------------

class TestInboxPersistence:
    def test_save_load_roundtrip(self, tmp_path):
        inbox = Inbox()
        inbox.add(_item("A", "stmt A"), ItemCategory.THEOREM, InboxOrigin.EXTRACTION)
        inbox.add(
            _item("B", "stmt B"), ItemCategory.DEFINITION,
            InboxOrigin.AXIOM_STUB, created_during="parent",
        )
        inbox.entries["A"].status = InboxStatus.PROMOTED

        path = tmp_path / "inbox.json"
        inbox.save(path)

        inbox2 = Inbox()
        inbox2.load(path)

        assert len(inbox2.entries) == 2
        assert inbox2.entries["A"].status == InboxStatus.PROMOTED
        assert inbox2.entries["B"].origin == InboxOrigin.AXIOM_STUB
        assert inbox2.entries["B"].created_during == "parent"

    def test_preserves_screening_metadata(self, tmp_path):
        inbox = Inbox()
        inbox.add(_item("A"), ItemCategory.THEOREM, InboxOrigin.EXTRACTION)
        inbox.entries["A"].screening_verdict = "partial"
        inbox.entries["A"].matched_name = "Nat.add_comm"
        inbox.entries["A"].similarity = 0.75

        path = tmp_path / "inbox.json"
        inbox.save(path)

        inbox2 = Inbox()
        inbox2.load(path)

        assert inbox2.entries["A"].screening_verdict == "partial"
        assert inbox2.entries["A"].matched_name == "Nat.add_comm"
        assert inbox2.entries["A"].similarity == 0.75

    def test_load_nonexistent_file(self, tmp_path):
        inbox = Inbox()
        inbox.load(tmp_path / "nonexistent.json")
        assert len(inbox.entries) == 0


# ---------------------------------------------------------------------------
# Promote integration (via Pipeline)
# ---------------------------------------------------------------------------

class TestPromote:
    def test_promote_new_items_to_backlog(self):
        pipeline = Pipeline()
        pipeline.inbox.add(
            _item("Thm_1", "Some theorem"),
            ItemCategory.THEOREM, InboxOrigin.EXTRACTION,
        )

        n = pipeline.promote()

        assert n == 1
        assert pipeline.inbox.entries["Thm_1"].status == InboxStatus.PROMOTED
        assert pipeline.backlog.get("Thm_1") is not None

    def test_exact_match_marked_duplicate(self):
        library = InMemoryLibrary()
        library.add("Thm_1", "Some theorem about compactness.")
        pipeline = Pipeline(library=library)

        pipeline.inbox.add(
            _item("Thm_1", "Some theorem about compactness."),
            ItemCategory.THEOREM, InboxOrigin.EXTRACTION,
        )

        n = pipeline.promote()

        assert n == 0
        assert pipeline.inbox.entries["Thm_1"].status == InboxStatus.DUPLICATE
        assert pipeline.backlog.get("Thm_1") is None

    def test_axiom_stubs_enter_as_axiomatized(self):
        pipeline = Pipeline()
        pipeline.inbox.add(
            _item("Ax_1", "some axiom"),
            ItemCategory.THEOREM, InboxOrigin.AXIOM_STUB,
            created_during="parent_thm",
        )

        n = pipeline.promote()

        assert n == 1
        entry = pipeline.backlog.get("Ax_1")
        assert entry is not None
        from leanknowledge.backlog import BacklogStatus
        assert entry.status == BacklogStatus.AXIOMATIZED
        assert entry.dependency_info.created_during == "parent_thm"

    def test_decomposition_items_enter_as_ready(self):
        pipeline = Pipeline()
        pipeline.inbox.add(
            _item("Sub_1", "sub-lemma"),
            ItemCategory.THEOREM, InboxOrigin.DECOMPOSITION,
        )

        n = pipeline.promote()

        assert n == 1
        entry = pipeline.backlog.get("Sub_1")
        assert entry is not None
        from leanknowledge.backlog import BacklogStatus
        assert entry.status == BacklogStatus.READY

    def test_already_promoted_skipped(self):
        pipeline = Pipeline()
        pipeline.inbox.add(
            _item("Thm_1", "theorem"),
            ItemCategory.THEOREM, InboxOrigin.EXTRACTION,
        )
        pipeline.promote()

        # Second promote should not re-promote
        n = pipeline.promote()
        assert n == 0

    def test_rescreen_catches_new_duplicates(self):
        pipeline = Pipeline()
        pipeline.inbox.add(
            _item("Thm_1", "Some theorem."),
            ItemCategory.THEOREM, InboxOrigin.EXTRACTION,
        )
        # First promote: no library entries → promoted
        pipeline.promote()
        assert pipeline.inbox.entries["Thm_1"].status == InboxStatus.PROMOTED

        # Now add the item to the library (simulating Rosetta Stone growth)
        library = InMemoryLibrary()
        library.add("Thm_1", "Some theorem.")
        pipeline.librarian = LibrarianAgent(library)

        # Re-screen: should mark as DUPLICATE
        n = pipeline.promote(rescreen=True)
        assert n == 0
        assert pipeline.inbox.entries["Thm_1"].status == InboxStatus.DUPLICATE

    def test_empty_inbox_returns_zero(self):
        pipeline = Pipeline()
        n = pipeline.promote()
        assert n == 0
