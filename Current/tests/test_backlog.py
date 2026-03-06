"""Tests for the Backlog with dependency resolution."""

from leanknowledge.schemas import ExtractedItem, StatementType, ClaimRole
from leanknowledge.agents.triage import ItemCategory
from leanknowledge.backlog import (
    Backlog, BacklogEntry, BacklogStatus, DependencyType,
)


def _item(id: str, statement: str = "test", deps: list[str] | None = None) -> ExtractedItem:
    return ExtractedItem(
        id=id, type=StatementType.THEOREM, role=ClaimRole.CLAIMED_RESULT,
        statement=statement, section="1.A", labeled=True,
        dependencies=deps or [],
    )


class TestBacklogBasic:
    def test_add_and_get(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("Thm_1"), category=ItemCategory.THEOREM))
        assert bl.get("Thm_1") is not None
        # No dependencies → auto-resolves to READY
        assert bl.get("Thm_1").status == BacklogStatus.READY

    def test_duplicate_add_skipped(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("Thm_1"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(item=_item("Thm_1"), category=ItemCategory.THEOREM))
        assert len(bl.entries) == 1

    def test_add_axiomatized(self):
        bl = Backlog()
        entry = bl.add_axiomatized(
            item=_item("Dep_1", "Monotone comparative statics theorem"),
            category=ItemCategory.THEOREM,
            dependency_type=DependencyType.CITATION,
            has_citation=True,
            citation_source="Milgrom & Shannon 1994, Theorem 2",
            lean_axiom_name="axiom_dep_1",
            created_during="Thm_5",
        )
        assert entry.status == BacklogStatus.AXIOMATIZED
        assert entry.dependency_info.has_citation is True
        assert entry.dependency_info.citation_source == "Milgrom & Shannon 1994, Theorem 2"
        assert entry.dependency_info.lean_axiom_name == "axiom_dep_1"
        assert entry.dependency_info.created_during == "Thm_5"

    def test_axiomatized_existing_returns_existing(self):
        bl = Backlog()
        bl.add(BacklogEntry(
            item=_item("Dep_1"), category=ItemCategory.THEOREM,
            status=BacklogStatus.COMPLETED,
        ))
        entry = bl.add_axiomatized(
            item=_item("Dep_1"),
            category=ItemCategory.THEOREM,
            dependency_type=DependencyType.CITATION,
        )
        assert entry.status == BacklogStatus.COMPLETED

    def test_mark_completed(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("Thm_1"), category=ItemCategory.THEOREM))
        bl.mark_completed("Thm_1", lean_file="LeanProject/Thm_1.lean")
        assert bl.get("Thm_1").status == BacklogStatus.COMPLETED
        assert bl.get("Thm_1").lean_file == "LeanProject/Thm_1.lean"
        assert bl.get("Thm_1").completed_at is not None

    def test_mark_failed(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("Thm_1"), category=ItemCategory.THEOREM))
        bl.mark_in_progress("Thm_1")
        bl.mark_failed("Thm_1", reason="type mismatch in line 5")
        assert bl.get("Thm_1").status == BacklogStatus.FAILED
        assert bl.get("Thm_1").attempts == 1

    def test_stats(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(item=_item("T2"), category=ItemCategory.THEOREM))
        bl.add_axiomatized(
            item=_item("D1"), category=ItemCategory.THEOREM,
            dependency_type=DependencyType.CLAIMED_KNOWN,
        )
        bl.mark_completed("T1", lean_file="t1.lean")

        stats = bl.stats
        assert stats["ready"] == 1       # T2: no deps → READY
        assert stats["completed"] == 1   # T1
        assert stats["axiomatized"] == 1 # D1

    def test_filter_methods(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("T1"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(item=_item("T2"), category=ItemCategory.THEOREM))
        bl.add_axiomatized(
            item=_item("D1"), category=ItemCategory.DEFINITION,
            dependency_type=DependencyType.IMPLICIT,
        )
        bl.mark_completed("T1", lean_file="t1.lean")

        assert len(bl.ready()) == 1       # T2
        assert len(bl.axiomatized()) == 1 # D1
        assert len(bl.completed()) == 1   # T1


class TestDependencyResolution:
    def test_no_deps_is_ready(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("A"), category=ItemCategory.THEOREM))
        assert bl.get("A").status == BacklogStatus.READY

    def test_external_dep_is_ready(self):
        """Dependencies not in backlog are treated as external (resolved)."""
        bl = Backlog()
        bl.add(BacklogEntry(
            item=_item("A", deps=["some_mathlib_lemma"]),
            category=ItemCategory.THEOREM,
        ))
        assert bl.get("A").status == BacklogStatus.READY

    def test_unresolved_dep_is_blocked(self):
        """If a dependency is in the backlog but not resolved → BLOCKED."""
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("B"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(
            item=_item("A", deps=["B"]),
            category=ItemCategory.THEOREM,
        ))
        assert bl.get("A").status == BacklogStatus.BLOCKED

    def test_resolved_dep_is_ready(self):
        """If a dependency is COMPLETED → item is READY."""
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("B"), category=ItemCategory.THEOREM))
        bl.mark_completed("B", lean_file="b.lean")
        bl.add(BacklogEntry(
            item=_item("A", deps=["B"]),
            category=ItemCategory.THEOREM,
        ))
        assert bl.get("A").status == BacklogStatus.READY

    def test_axiomatized_dep_counts_as_resolved(self):
        bl = Backlog()
        bl.add_axiomatized(
            item=_item("B"),
            category=ItemCategory.THEOREM,
            dependency_type=DependencyType.CITATION,
        )
        bl.add(BacklogEntry(
            item=_item("A", deps=["B"]),
            category=ItemCategory.THEOREM,
        ))
        assert bl.get("A").status == BacklogStatus.READY

    def test_completion_propagates(self):
        """Completing B should unblock A."""
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("B"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(
            item=_item("A", deps=["B"]),
            category=ItemCategory.THEOREM,
        ))
        assert bl.get("A").status == BacklogStatus.BLOCKED

        unblocked = bl.mark_completed("B", lean_file="b.lean")
        assert bl.get("A").status == BacklogStatus.READY
        assert "A" in unblocked

    def test_axiomatization_propagates(self):
        """Axiomatizing B should unblock A."""
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("B"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(
            item=_item("A", deps=["B"]),
            category=ItemCategory.THEOREM,
        ))
        assert bl.get("A").status == BacklogStatus.BLOCKED

        # Simulate axiomatization: mark B as axiomatized by adding it again
        # (In practice, the prover creates axiomatized entries for new deps)
        bl.entries["B"].status = BacklogStatus.AXIOMATIZED
        bl._propagate("B")
        assert bl.get("A").status == BacklogStatus.READY

    def test_multiple_deps_all_needed(self):
        """Item stays BLOCKED until ALL deps are resolved."""
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("B"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(item=_item("C"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(
            item=_item("A", deps=["B", "C"]),
            category=ItemCategory.THEOREM,
        ))
        assert bl.get("A").status == BacklogStatus.BLOCKED

        bl.mark_completed("B", lean_file="b.lean")
        assert bl.get("A").status == BacklogStatus.BLOCKED  # still waiting on C

        bl.mark_completed("C", lean_file="c.lean")
        assert bl.get("A").status == BacklogStatus.READY

    def test_chain_propagation(self):
        """A depends on B, B depends on C. Completing C should unblock B, then A."""
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("C"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(
            item=_item("B", deps=["C"]),
            category=ItemCategory.THEOREM,
        ))
        bl.add(BacklogEntry(
            item=_item("A", deps=["B"]),
            category=ItemCategory.THEOREM,
        ))

        assert bl.get("B").status == BacklogStatus.BLOCKED
        assert bl.get("A").status == BacklogStatus.BLOCKED

        # Complete C → B unblocks
        unblocked_1 = bl.mark_completed("C", lean_file="c.lean")
        assert "B" in unblocked_1
        assert bl.get("B").status == BacklogStatus.READY
        # A is still blocked (B is READY, not COMPLETED)
        assert bl.get("A").status == BacklogStatus.BLOCKED

        # Complete B → A unblocks
        bl.mark_in_progress("B")
        unblocked_2 = bl.mark_completed("B", lean_file="b.lean")
        assert "A" in unblocked_2
        assert bl.get("A").status == BacklogStatus.READY

    def test_unresolved_deps_query(self):
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("B"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(item=_item("C"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(
            item=_item("A", deps=["B", "C", "ext_lemma"]),
            category=ItemCategory.THEOREM,
        ))

        unresolved = bl.unresolved_deps("A")
        # B and C are in backlog but not resolved; ext_lemma is external → resolved
        assert "B" in unresolved
        assert "C" in unresolved
        assert "ext_lemma" not in unresolved

    def test_resolve_all_migrates_pending(self):
        """resolve_all() converts old PENDING items to READY/BLOCKED."""
        bl = Backlog()
        # Manually add as PENDING (simulating old backlog load)
        bl.entries["A"] = BacklogEntry(
            item=_item("A"), category=ItemCategory.THEOREM,
            status=BacklogStatus.PENDING,
        )
        bl.entries["B"] = BacklogEntry(
            item=_item("B", deps=["A"]), category=ItemCategory.THEOREM,
            status=BacklogStatus.PENDING,
        )

        bl.resolve_all()
        assert bl.get("A").status == BacklogStatus.READY
        assert bl.get("B").status == BacklogStatus.BLOCKED

    def test_failed_dep_does_not_resolve(self):
        """FAILED items don't count as resolved."""
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("B"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(
            item=_item("A", deps=["B"]),
            category=ItemCategory.THEOREM,
        ))
        bl.mark_in_progress("B")
        bl.mark_failed("B", reason="could not prove")

        assert bl.get("A").status == BacklogStatus.BLOCKED

    def test_in_progress_dep_does_not_resolve(self):
        """IN_PROGRESS items don't count as resolved."""
        bl = Backlog()
        bl.add(BacklogEntry(item=_item("B"), category=ItemCategory.THEOREM))
        bl.add(BacklogEntry(
            item=_item("A", deps=["B"]),
            category=ItemCategory.THEOREM,
        ))
        bl.mark_in_progress("B")

        assert bl.get("A").status == BacklogStatus.BLOCKED
