"""Tests for Agent 5: Proof Structurer schemas and prompt building."""

from leanknowledge.schemas import (
    ExtractedItem, StatementType, ClaimRole,
    StructuredProof, ProofStrategy, Assumption, Dependency, ProofStep,
)
from leanknowledge.agents.proof_structurer import ProofStructurer


def _item(id: str, statement: str, proof: str | None = None, **kw) -> ExtractedItem:
    return ExtractedItem(
        id=id, type=StatementType.THEOREM, role=ClaimRole.CLAIMED_RESULT,
        statement=statement, proof=proof, section="1.A", labeled=True, **kw,
    )


class TestStructuredProofSchema:
    def test_minimal_proof(self):
        proof = StructuredProof(
            theorem_name="Thm_1",
            strategy=ProofStrategy.DIRECT,
            goal_statement="If X is compact, f(X) is compact.",
            steps=[ProofStep(
                step_number=1,
                description="Apply image_compact",
                justification="By CompactSpace.image_compact",
            )],
            conclusion="f(X) is compact by direct application.",
        )
        assert proof.strategy == ProofStrategy.DIRECT
        assert len(proof.steps) == 1

    def test_proof_with_dependencies(self):
        proof = StructuredProof(
            theorem_name="Thm_2",
            strategy=ProofStrategy.CONTRADICTION,
            goal_statement="The strict preference is irreflexive.",
            assumptions=[
                Assumption(name="h_rational", statement="≿ is rational",
                           lean_type_hint="IsTotal X (· ≤ ·)"),
            ],
            dependencies=[
                Dependency(name="completeness", statement="≿ is complete",
                           source="Definition 1.B.1", usage="Step 1"),
            ],
            steps=[
                ProofStep(step_number=1, description="Assume x ≻ x",
                          justification="For contradiction",
                          lean_tactic_hint="intro h"),
                ProofStep(step_number=2, description="Derive contradiction",
                          justification="By asymmetry from completeness",
                          lean_tactic_hint="exact absurd h (irrefl x)"),
            ],
            conclusion="Strict preference is irreflexive.",
        )
        assert len(proof.assumptions) == 1
        assert len(proof.dependencies) == 1
        assert proof.dependencies[0].source == "Definition 1.B.1"

    def test_substeps(self):
        proof = StructuredProof(
            theorem_name="Thm_3",
            strategy=ProofStrategy.CONSTRUCTION,
            goal_statement="There exists an epsilon...",
            steps=[
                ProofStep(
                    step_number=1,
                    description="Construct the witness",
                    justification="By choosing epsilon = delta/2",
                    substeps=[
                        ProofStep(step_number=1, description="Choose delta/2",
                                  justification="delta > 0 by assumption"),
                        ProofStep(step_number=2, description="Verify bound",
                                  justification="delta/2 < delta"),
                    ],
                ),
            ],
            conclusion="Witness constructed.",
        )
        assert len(proof.steps[0].substeps) == 2


class TestPromptBuilding:
    def test_prompt_includes_statement(self):
        agent = ProofStructurer(model="test")
        item = _item("Thm_1", "If X is compact, f(X) is compact.")
        prompt = agent._build_prompt(item, "")
        assert "If X is compact" in prompt
        assert "Thm_1" in prompt

    def test_prompt_includes_proof(self):
        agent = ProofStructurer(model="test")
        item = _item("Thm_1", "X is compact.", proof="By the Heine-Borel theorem...")
        prompt = agent._build_prompt(item, "")
        assert "Heine-Borel" in prompt

    def test_prompt_includes_sketch_when_no_proof(self):
        agent = ProofStructurer(model="test")
        item = _item("Thm_1", "X is compact.", proof_sketch="Follows from closedness")
        prompt = agent._build_prompt(item, "")
        assert "closedness" in prompt

    def test_prompt_includes_dependencies(self):
        agent = ProofStructurer(model="test")
        item = _item("Thm_1", "X is compact.",
                      dependencies=["Def_1", "Lemma_2"])
        prompt = agent._build_prompt(item, "")
        assert "Def_1" in prompt
        assert "Lemma_2" in prompt

    def test_prompt_includes_notation(self):
        agent = ProofStructurer(model="test")
        item = _item("Thm_1", "≿ is transitive.",
                      notation_in_scope={"≿": "preference relation"})
        prompt = agent._build_prompt(item, "")
        assert "≿ = preference relation" in prompt

    def test_prompt_includes_context(self):
        agent = ProofStructurer(model="test")
        item = _item("Thm_1", "X is compact.")
        prompt = agent._build_prompt(item, "This appears in Chapter 3 on topology.")
        assert "Chapter 3" in prompt
