"""Tests for Agent 4: Librarian deduplication gate."""

from leanknowledge.schemas import ExtractedItem, ExtractionResult, StatementType, ClaimRole
from leanknowledge.agents.triage import TriageAgent
from leanknowledge.agents.librarian import (
    LibrarianAgent, InMemoryLibrary, MatchType,
)


def _item(id: str, statement: str, type: StatementType = StatementType.THEOREM) -> ExtractedItem:
    return ExtractedItem(
        id=id, type=type, role=ClaimRole.CLAIMED_RESULT,
        statement=statement, section="1.A", labeled=True,
    )


def _make_inbox(items: list[ExtractedItem]):
    extraction = ExtractionResult(source="test", items=items)
    return TriageAgent().triage(extraction)


class TestLibrarian:
    def test_exact_match_skipped(self):
        lib = InMemoryLibrary()
        lib.add("Thm_1", "If X is compact and f is continuous, then f(X) is compact.",
                source="mathlib")

        inbox = _make_inbox([
            _item("Thm_1", "If X is compact and f is continuous, then f(X) is compact."),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.exact_matches) == 1
        assert len(result.to_backlog) == 0
        assert result.exact_matches[0].matched_source == "mathlib"

    def test_no_match_goes_to_backlog(self):
        lib = InMemoryLibrary()  # empty library

        inbox = _make_inbox([
            _item("Thm_1", "Every bounded sequence in R^n has a convergent subsequence."),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.no_matches) == 1
        assert len(result.to_backlog) == 1

    def test_partial_match_goes_to_backlog(self):
        """A related but not identical statement → partial match → backlog."""
        lib = InMemoryLibrary()
        lib.add("compact_image", "If f is continuous and K is compact, then f(K) is compact.",
                source="mathlib")

        inbox = _make_inbox([
            # Same idea, different wording + extra condition
            _item("Thm_1", "If f is continuous and K is compact in a metric space, then f(K) is compact and bounded."),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.to_backlog) == 1
        # Should be partial, not exact (the statements differ meaningfully)
        verdict = result.to_backlog[0]
        assert verdict.match_type in (MatchType.PARTIAL, MatchType.NONE)

    def test_definitions_also_checked(self):
        """Definitions go through the librarian too."""
        lib = InMemoryLibrary()
        lib.add("ContinuousOn", "A function f is continuous on S if ...",
                source="mathlib")

        inbox = _make_inbox([
            _item("Def_cont", "A function f is continuous on S if ...",
                  type=StatementType.DEFINITION),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.exact_matches) == 1

    def test_mixed_inbox(self):
        """Some items match, some don't."""
        lib = InMemoryLibrary()
        lib.add("reflexivity", "Completeness implies reflexivity.",
                source="knowledge_tree")

        inbox = _make_inbox([
            _item("Claim_1", "Completeness implies reflexivity."),
            _item("Thm_2", "The strict preference relation is transitive."),
            _item("Def_1", "A preference is rational if complete and transitive.",
                  type=StatementType.DEFINITION),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.exact_matches) == 1  # Claim_1
        assert len(result.to_backlog) == 2     # Thm_2 + Def_1

    def test_empty_library(self):
        lib = InMemoryLibrary()
        inbox = _make_inbox([
            _item("Thm_1", "Something new."),
            _item("Thm_2", "Something else new."),
        ])

        result = LibrarianAgent(lib).check(inbox)
        assert len(result.exact_matches) == 0
        assert len(result.to_backlog) == 2

    def test_empty_inbox(self):
        lib = InMemoryLibrary()
        lib.add("Thm_1", "Some theorem.", source="mathlib")

        inbox = _make_inbox([])
        result = LibrarianAgent(lib).check(inbox)
        assert len(result.to_backlog) == 0
        assert len(result.exact_matches) == 0
