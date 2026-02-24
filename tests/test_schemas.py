from leanknowledge.schemas import (
    ExtractedItem,
    StatementType,
    ClaimRole,
    Domain,
    TheoremInput,
    StructuredProof,
    ProofStrategy,
    LeanCode,
    BacklogEntry,
    BacklogStatus
)
import pytest
from pydantic import ValidationError

def test_extracted_item_valid():
    item = ExtractedItem(
        id="Theorem 1",
        type=StatementType.THEOREM,
        statement="x + y = y + x",
        section="1.1",
        context="In a commutative group..."
    )
    assert item.id == "Theorem 1"
    assert item.role == ClaimRole.CLAIMED_RESULT
    assert item.labeled is True

def test_extracted_item_invalid():
    with pytest.raises(ValidationError):
        ExtractedItem(
            id="Theorem 1",
            # Missing type and statement
            section="1.1"
        )

def test_theorem_input_domain():
    theorem = TheoremInput(
        name="Test",
        statement="P -> Q",
        domain=Domain.LOGIC
    )
    assert theorem.domain == "logic"
    
    with pytest.raises(ValidationError):
        TheoremInput(
            name="Test",
            statement="P -> Q",
            domain="invalid_domain" # Should fail validation
        )

def test_structured_proof():
    proof = StructuredProof(
        theorem_name="Test",
        strategy=ProofStrategy.DIRECT,
        assumptions=["P"],
        dependencies=["Lemma 1"],
        steps=[{"description": "Assume P", "justification": "hypothesis"}],
        conclusion="Q"
    )
    assert len(proof.steps) == 1
    assert proof.strategy == "direct"

def test_backlog_entry_defaults():
    item = ExtractedItem(
        id="T1", type=StatementType.THEOREM, statement="S", section="1"
    )
    entry = BacklogEntry(
        item=item,
        source="Book",
        domain=Domain.ALGEBRA
    )
    assert entry.status == BacklogStatus.PENDING
    assert entry.priority_score == 0
    assert entry.attempts == 0
