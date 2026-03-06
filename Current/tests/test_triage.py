"""Tests for Agent 3: Triage classification."""

from leanknowledge.schemas import ExtractedItem, ExtractionResult, StatementType, ClaimRole
from leanknowledge.agents.triage import TriageAgent, classify, ItemCategory


def _item(id: str, type: StatementType, role: ClaimRole = ClaimRole.CLAIMED_RESULT) -> ExtractedItem:
    return ExtractedItem(
        id=id, type=type, role=role,
        statement="test statement", section="1.A", labeled=True,
    )


class TestClassify:
    def test_definition_type(self):
        assert classify(_item("Def_1", StatementType.DEFINITION)) == ItemCategory.DEFINITION

    def test_axiom_becomes_definition(self):
        """Axioms are treated as definitions — they define the structure."""
        assert classify(_item("Ax_1", StatementType.AXIOM)) == ItemCategory.DEFINITION

    def test_implicit_assumption_is_definition(self):
        assert classify(_item("IA_1", StatementType.IMPLICIT_ASSUMPTION)) == ItemCategory.DEFINITION

    def test_theorem_type(self):
        assert classify(_item("Thm_1", StatementType.THEOREM)) == ItemCategory.THEOREM

    def test_proposition_is_theorem(self):
        assert classify(_item("Prop_1", StatementType.PROPOSITION)) == ItemCategory.THEOREM

    def test_lemma_is_theorem(self):
        assert classify(_item("Lem_1", StatementType.LEMMA)) == ItemCategory.THEOREM

    def test_corollary_is_theorem(self):
        assert classify(_item("Cor_1", StatementType.COROLLARY)) == ItemCategory.THEOREM

    def test_claim_is_theorem(self):
        assert classify(_item("Claim_1", StatementType.CLAIM)) == ItemCategory.THEOREM

    def test_example_with_definition_role(self):
        """An example that introduces a concept → definition."""
        item = _item("Ex_1", StatementType.EXAMPLE, role=ClaimRole.DEFINITION)
        assert classify(item) == ItemCategory.DEFINITION

    def test_remark_defaults_to_theorem(self):
        """A remark asserting something is true → theorem."""
        item = _item("Rem_1", StatementType.REMARK)
        assert classify(item) == ItemCategory.THEOREM


class TestTriageAgent:
    def test_triage_splits_correctly(self):
        extraction = ExtractionResult(
            source="MWG Chapter 1",
            items=[
                _item("Def_1.B.1", StatementType.DEFINITION),
                _item("Axiom_1", StatementType.AXIOM),
                _item("Prop_1.B.1", StatementType.PROPOSITION),
                _item("Claim_1.B.a", StatementType.CLAIM),
                _item("Thm_1.C.1", StatementType.THEOREM),
            ],
        )
        agent = TriageAgent()
        inbox = agent.triage(extraction)

        assert len(inbox.items) == 5
        assert len(inbox.definitions) == 2  # Def + Axiom
        assert len(inbox.theorems) == 3     # Prop + Claim + Thm

    def test_triage_preserves_order(self):
        extraction = ExtractionResult(
            source="test",
            items=[
                _item("A", StatementType.DEFINITION),
                _item("B", StatementType.THEOREM),
                _item("C", StatementType.DEFINITION),
            ],
        )
        inbox = TriageAgent().triage(extraction)
        ids = [i.item.id for i in inbox.items]
        assert ids == ["A", "B", "C"]

    def test_empty_extraction(self):
        extraction = ExtractionResult(source="empty", items=[])
        inbox = TriageAgent().triage(extraction)
        assert len(inbox.items) == 0
