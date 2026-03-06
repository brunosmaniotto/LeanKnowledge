"""Tests for Agent 2 disagreement detection and merging."""

from leanknowledge.schemas import ExtractionResult, ExtractedItem, StatementType, ClaimRole
from leanknowledge.agents.claim_extraction import assess_agreement, _merge_results


def _item(id: str, statement: str, **kwargs) -> ExtractedItem:
    """Helper to create test items."""
    return ExtractedItem(
        id=id,
        type=kwargs.get("type", StatementType.THEOREM),
        role=kwargs.get("role", ClaimRole.CLAIMED_RESULT),
        statement=statement,
        section=kwargs.get("section", "1.A"),
        labeled=kwargs.get("labeled", True),
        **{k: v for k, v in kwargs.items()
           if k not in ("type", "role", "section", "labeled")},
    )


def _result(items: list[ExtractedItem]) -> ExtractionResult:
    return ExtractionResult(source="test", items=items)


class TestAgreement:
    def test_identical_extractions_agree(self):
        items = [_item("Thm_1", "If X is compact, then f(X) is compact.")]
        a = assess_agreement(_result(items), _result(items))
        assert a["agree"] is True

    def test_both_empty_agree(self):
        a = assess_agreement(_result([]), _result([]))
        assert a["agree"] is True

    def test_similar_statements_agree(self):
        """Minor wording differences should still count as agreement."""
        items_a = [_item("Thm_1", "If X is compact and f is continuous, then f(X) is compact.")]
        items_b = [_item("Thm_1", "If X is compact and f is continuous then f(X) is compact")]
        a = assess_agreement(_result(items_a), _result(items_b))
        assert a["agree"] is True

    def test_count_divergence_triggers_disagreement(self):
        """One model finds 10 items, the other finds 3 — that's a disagreement."""
        many = [_item(f"Thm_{i}", f"Statement number {i} about topology.") for i in range(10)]
        few = [_item(f"Thm_{i}", f"Statement number {i} about topology.") for i in range(3)]
        a = assess_agreement(_result(many), _result(few))
        assert a["agree"] is False
        assert "count_divergence" in a["reason"]

    def test_low_overlap_triggers_disagreement(self):
        """Same count but completely different items."""
        items_a = [
            _item("Def_1", "A topological space is a set X with a topology T."),
            _item("Thm_1", "Every compact subset of a Hausdorff space is closed."),
        ]
        items_b = [
            _item("Def_2", "A metric space is a set with a distance function."),
            _item("Thm_2", "The Bolzano-Weierstrass theorem holds in R^n."),
        ]
        a = assess_agreement(_result(items_a), _result(items_b))
        assert a["agree"] is False

    def test_one_extra_item_still_agrees(self):
        """One model finds a bonus item — that's fine, not a disagreement."""
        shared = [
            _item("Def_1", "A preference relation is rational if complete and transitive."),
            _item("Thm_1", "Completeness implies reflexivity."),
        ]
        extra = shared + [_item("Claim_a", "The strict preference is irreflexive.")]
        a = assess_agreement(_result(shared), _result(extra))
        assert a["agree"] is True


class TestMerging:
    def test_merge_keeps_all_unique_items(self):
        items_a = [
            _item("Def_1", "A set is open if it contains a neighborhood of each point."),
            _item("Thm_1", "The union of open sets is open."),
        ]
        items_b = [
            _item("Def_1", "A set is open if it contains a neighborhood of each point."),
            _item("Claim_a", "The empty set is open."),
        ]
        merged = _merge_results(_result(items_a), _result(items_b), "test")
        assert len(merged.items) == 3  # Def_1 + Thm_1 + Claim_a

    def test_merge_deduplicates(self):
        items = [_item("Thm_1", "Completeness implies reflexivity.")]
        merged = _merge_results(_result(items), _result(items), "test")
        assert len(merged.items) == 1
