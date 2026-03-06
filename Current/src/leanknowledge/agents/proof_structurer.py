"""Agent 5: Proof Structurer — transforms NL proofs into structured proof plans.

Takes a theorem statement + NL proof and produces a StructuredProof:
explicit strategy, atomic steps, named dependencies, tactic hints.

The intelligence lives in the prompt (prompts/proof_structurer.md).
This agent is a thin LLM wrapper. Iterate on the prompt, not the code.
"""

import os
from pathlib import Path

from ..schemas import StructuredProof, ExtractedItem
from ..llm import complete_json, MODEL_FAST_A, MODEL_HEAVY

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "proof_structurer.md"

# Default to a strong reasoning model — this agent needs to understand math
DEFAULT_MODEL = os.environ.get("LK_STRUCTURER_MODEL", MODEL_HEAVY)


class ProofStructurer:
    """Agent 5: Structure NL proofs for downstream translation to Lean 4.

    Uses a strong reasoning model by default (Opus). The structured output
    is designed to make the translator's job mechanical.
    """

    def __init__(self, model: str = DEFAULT_MODEL):
        self.model = model

    def structure(
        self,
        item: ExtractedItem,
        source_context: str = "",
    ) -> StructuredProof:
        """Structure a proof for translation.

        Args:
            item: the extracted claim (must have statement; proof/proof_sketch optional)
            source_context: additional context from the source text

        Returns:
            StructuredProof ready for the translator
        """
        system = PROMPT_PATH.read_text() if PROMPT_PATH.exists() else ""

        prompt = self._build_prompt(item, source_context)

        print(f"  [Agent 5] Structuring proof for: {item.id}")
        data = complete_json(self.model, prompt, system=system, max_tokens=8192)
        result = StructuredProof.model_validate(data)
        print(f"    Strategy: {result.strategy.value}, "
              f"{len(result.steps)} steps, "
              f"{len(result.dependencies)} dependencies")
        return result

    def _build_prompt(self, item: ExtractedItem, source_context: str) -> str:
        parts = [
            f"Theorem name: {item.id}",
            f"Statement: {item.statement}",
        ]

        if item.proof:
            parts.append(f"\nNatural-language proof:\n{item.proof}")
        elif item.proof_sketch:
            parts.append(f"\nProof sketch:\n{item.proof_sketch}")
        else:
            parts.append("\nNo proof provided. Construct one from the statement.")

        if item.dependencies:
            parts.append(f"\nKnown dependencies: {', '.join(item.dependencies)}")

        if item.notation_in_scope:
            notation = ", ".join(f"{k} = {v}" for k, v in item.notation_in_scope.items())
            parts.append(f"\nNotation in scope: {notation}")

        if source_context:
            parts.append(f"\nAdditional context from source:\n{source_context}")

        parts.append(
            "\n\nProduce a structured proof plan following the format "
            "specified in your system prompt. Respond with ONLY valid JSON."
        )

        return "\n".join(parts)
