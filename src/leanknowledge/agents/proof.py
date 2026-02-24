"""Stage 1: Proof Agent — generates structured natural language proofs.

Supports both Claude Code (default) and DeepSeek-Prover-V2 as backends.
"""

from collections.abc import Callable
from pathlib import Path

from ..schemas import TheoremInput, StructuredProof
from ..claude_client import call_claude

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "proof_agent.md"


class ProofAgent:
    def __init__(self, call_fn: Callable | None = None):
        """Initialize with optional custom LLM call function.

        Args:
            call_fn: Function with same signature as call_claude().
                     If None, uses Claude Code CLI.
        """
        self.call_fn = call_fn or call_claude

    def generate(self, theorem: TheoremInput, strategy_hints: str = "") -> StructuredProof:
        system = PROMPT_PATH.read_text()
        prompt = (
            f"Theorem: {theorem.name}\n"
            f"Statement: {theorem.statement}\n"
            f"Domain: {theorem.domain.value}\n"
            + (f"Source: {theorem.source}\n" if theorem.source else "")
        )
        if strategy_hints:
            prompt += f"\n## Strategy Guidance\n{strategy_hints}\n"

        data = self.call_fn(prompt, system=system, schema=StructuredProof, caller="proof.generate")
        return StructuredProof.model_validate(data)

    def revise(self, theorem: TheoremInput, previous_proof: StructuredProof, failure_reason: str, strategy_hints: str = "") -> StructuredProof:
        """Re-generate proof with a different strategy after verification failure."""
        system = PROMPT_PATH.read_text()
        prompt = (
            f"Theorem: {theorem.name}\n"
            f"Statement: {theorem.statement}\n"
            f"Domain: {theorem.domain.value}\n\n"
            f"A previous proof attempt using strategy '{previous_proof.strategy.value}' "
            f"failed during Lean formalization.\n"
            f"Failure reason: {failure_reason}\n\n"
            f"Please try a DIFFERENT proof strategy."
        )
        if strategy_hints:
            prompt += f"\n\n## Strategy Guidance\n{strategy_hints}\n"

        data = self.call_fn(prompt, system=system, schema=StructuredProof, caller="proof.revise")
        return StructuredProof.model_validate(data)
