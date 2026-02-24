"""Stage 2: Lean Translation Agent — converts structured NL proofs to Lean 4 code."""

import hashlib
import json
import re
from pathlib import Path

from ..schemas import StructuredProof, LeanCode, TheoremInput
from ..claude_client import call_claude

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "lean_translation.md"
AXIOM_PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "axiom_translation.md"
AXIOM_CACHE_PATH = Path(__file__).resolve().parents[3] / "outputs" / "axiom_cache.json"


def _slugify(name: str) -> str:
    """Convert a theorem name to a valid Lean identifier."""
    # Replace spaces, dots, and special chars with underscores
    slug = re.sub(r"[^a-zA-Z0-9_]", "_", name)
    # Collapse multiple underscores
    slug = re.sub(r"_+", "_", slug).strip("_")
    # Ensure it starts with a letter
    if slug and not slug[0].isalpha():
        slug = "thm_" + slug
    return slug or "unnamed_theorem"


def _cache_key(theorem: TheoremInput) -> str:
    """Generate a stable cache key from theorem name + statement + domain."""
    content = f"{theorem.name}|{theorem.statement}|{theorem.domain.value}"
    return hashlib.sha256(content.encode()).hexdigest()[:16]


class TranslatorAgent:
    def __init__(self, strategy_kb=None):
        self.strategy_kb = strategy_kb
        self._axiom_cache: dict[str, dict] = {}
        self._load_axiom_cache()

    def _load_axiom_cache(self):
        """Load cached axiom generations from disk."""
        if AXIOM_CACHE_PATH.exists():
            try:
                self._axiom_cache = json.loads(AXIOM_CACHE_PATH.read_text(encoding="utf-8"))
            except (json.JSONDecodeError, OSError):
                self._axiom_cache = {}

    def _save_axiom_cache(self):
        """Persist axiom cache to disk."""
        AXIOM_CACHE_PATH.parent.mkdir(parents=True, exist_ok=True)
        AXIOM_CACHE_PATH.write_text(
            json.dumps(self._axiom_cache, indent=2), encoding="utf-8"
        )

    def translate(self, proof: StructuredProof, tactic_hints: str = "") -> LeanCode:
        system = PROMPT_PATH.read_text()
        prompt = (
            f"Theorem: {proof.theorem_name}\n"
            f"Strategy: {proof.strategy.value}\n"
            f"Assumptions: {', '.join(proof.assumptions)}\n"
            f"Dependencies: {', '.join(proof.dependencies)}\n\n"
            f"Proof steps:\n"
            + "\n".join(
                f"  {i+1}. {step.description} [{step.justification}]"
                for i, step in enumerate(proof.steps)
            )
            + f"\n\nConclusion: {proof.conclusion}"
        )
        if tactic_hints:
            prompt += f"\n\n## Tactic Guidance\n{tactic_hints}\n"

        data = call_claude(prompt, system=system, schema=LeanCode, caller="translator.translate")
        return LeanCode.model_validate(data)

    def repair(
        self,
        proof: StructuredProof,
        lean_code: LeanCode,
        error_message: str,
        prior_fixes: list[str] | None = None,
    ) -> LeanCode:
        """Attempt to fix Lean code based on compiler errors.

        Args:
            prior_fixes: Descriptions of deterministic fixes already attempted
                         (from RepairDB). Included in prompt to avoid retrying.
        """
        system = PROMPT_PATH.read_text()
        prompt = (
            f"The following Lean 4 code failed to compile.\n\n"
            f"Code:\n```lean\n{lean_code.code}\n```\n\n"
            f"Compiler errors:\n{error_message}\n\n"
            f"Original proof structure:\n"
            f"Strategy: {proof.strategy.value}\n"
            f"Steps:\n"
            + "\n".join(
                f"  {i+1}. {step.description}"
                for i, step in enumerate(proof.steps)
            )
            + "\n\nPlease fix the Lean code."
        )

        if prior_fixes:
            fixes_text = "\n".join(f"  - {f}" for f in prior_fixes)
            prompt += (
                f"\n\nNote: The following automated fixes were already attempted "
                f"and did not resolve the errors:\n{fixes_text}\n"
                f"Try a different approach."
            )

        data = call_claude(prompt, system=system, schema=LeanCode, caller="translator.repair")
        return LeanCode.model_validate(data)

    def axiomatize(self, theorem: TheoremInput) -> LeanCode:
        """Generate a Lean axiom declaration (type signature only, no proof).

        Uses a cache to avoid repeated Claude calls for the same theorem.
        Falls back to a sorry-stub template if Claude is unavailable.
        """
        key = _cache_key(theorem)

        # Check cache first
        if key in self._axiom_cache:
            cached = self._axiom_cache[key]
            return LeanCode.model_validate(cached)

        # Try Claude for a proper typed axiom
        try:
            system = AXIOM_PROMPT_PATH.read_text()
            prompt = (
                f"Theorem: {theorem.name}\n"
                f"Statement: {theorem.statement}\n"
                f"Domain: {theorem.domain.value}\n"
            )
            if theorem.source:
                prompt += f"Source: {theorem.source}\n"
            data = call_claude(prompt, system=system, schema=LeanCode, caller="translator.axiomatize")
            result = LeanCode.model_validate(data)

            # Cache the successful result
            self._axiom_cache[key] = result.model_dump()
            self._save_axiom_cache()
            return result

        except Exception as e:
            # Fall back to sorry-stub template
            print(f"  [translator] Claude axiom generation failed ({e}), using sorry stub")
            lean_name = _slugify(theorem.name)
            code = (
                f"-- Axiomatized: {theorem.name}\n"
                f"-- {theorem.statement[:200]}\n"
                f"theorem {lean_name} : sorry := sorry"
            )
            return LeanCode(code=code)
