"""Agent 6: Translator — converts structured proofs into Lean 4 code.

Escalation system:
  1. Up to 5 attempts with DeepSeek (fine-tuned Goedel-Prover-V2)
  2. Up to 5 attempts with Opus
  3. Flag as "human attention needed"

CRUCIAL: each attempt carries the FULL history of previous attempts and
their compiler outputs. The model never tries blindly — it sees every
prior attempt and what went wrong.

Training data collection:
  Every attempt produces a triple:
    (structured_proof, lean_code, compiler_output)
  These triples train both the translator (RL) and the structurer
  (learn which structures lead to successful translations).
"""

import os
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path

from ..schemas import StructuredProof
from ..llm import complete, MODEL_FAST_B, MODEL_HEAVY
from ..prompt_tuner import PromptTuner

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "translator.md"

# Escalation config
MAX_ATTEMPTS_TIER1 = int(os.environ.get("LK_TRANSLATOR_TIER1_ATTEMPTS", "5"))
MAX_ATTEMPTS_TIER2 = int(os.environ.get("LK_TRANSLATOR_TIER2_ATTEMPTS", "5"))

TIER1_MODEL = os.environ.get("LK_TRANSLATOR_TIER1_MODEL", MODEL_FAST_B)
TIER2_MODEL = os.environ.get("LK_TRANSLATOR_TIER2_MODEL", MODEL_HEAVY)

# Max output tokens per tier (Goedel has 8K context total, needs headroom)
TIER1_MAX_TOKENS = int(os.environ.get("LK_TRANSLATOR_TIER1_MAX_TOKENS", "2048"))
TIER2_MAX_TOKENS = int(os.environ.get("LK_TRANSLATOR_TIER2_MAX_TOKENS", "8192"))


# ---------------------------------------------------------------------------
# Training triple
# ---------------------------------------------------------------------------

@dataclass
class TranslationTriple:
    """One attempt: structured proof → lean code → compiler output.

    Training data for both the translator (RL) and the structurer.
    """
    structured_proof: StructuredProof
    lean_code: str
    compiler_output: str       # full compiler message (error or success)
    compiled: bool             # convenience flag
    model: str                 # which model produced this attempt
    attempt_number: int        # 1-indexed within the current tier


class TranslationOutcome(str, Enum):
    SUCCESS = "success"
    FAILED_TIER1 = "failed_tier1"    # exhausted DeepSeek attempts
    FAILED_TIER2 = "failed_tier2"    # exhausted Opus attempts
    NEEDS_HUMAN = "needs_human"       # both tiers exhausted


@dataclass
class TranslationResult:
    """Full result of translating a structured proof."""
    outcome: TranslationOutcome
    lean_code: str | None = None             # final successful code (or last attempt)
    triples: list[TranslationTriple] = field(default_factory=list)
    total_attempts: int = 0

    @property
    def successful_triple(self) -> TranslationTriple | None:
        for t in self.triples:
            if t.compiled:
                return t
        return None


# ---------------------------------------------------------------------------
# Lean compiler interface (pluggable)
# ---------------------------------------------------------------------------

class LeanCompiler:
    """Interface for compiling Lean 4 code.

    Subclass for real compiler integration.
    """

    def compile(self, code: str) -> tuple[bool, str]:
        """Compile Lean code. Returns (success, compiler_output)."""
        raise NotImplementedError


# ---------------------------------------------------------------------------
# Prompt building
# ---------------------------------------------------------------------------

def _build_initial_prompt(proof: StructuredProof) -> str:
    """Build the first translation prompt (no history)."""
    proof_json = proof.model_dump_json(indent=2)
    return (
        f"Translate the following structured proof into Lean 4 code.\n\n"
        f"--- STRUCTURED PROOF ---\n{proof_json}\n--- END ---\n\n"
        f"Produce ONLY the Lean 4 code. No explanation, no markdown fences.\n"
        f"Include all necessary imports at the top."
    )


def _build_retry_prompt(
    proof: StructuredProof,
    history: list[TranslationTriple],
) -> str:
    """Build a retry prompt with full history of previous attempts."""
    proof_json = proof.model_dump_json(indent=2)

    history_parts = []
    for t in history:
        status = "COMPILED SUCCESSFULLY" if t.compiled else "FAILED"
        history_parts.append(
            f"--- ATTEMPT {t.attempt_number} ({t.model}) [{status}] ---\n"
            f"Code:\n{t.lean_code}\n\n"
            f"Compiler output:\n{t.compiler_output}\n"
            f"--- END ATTEMPT {t.attempt_number} ---"
        )

    history_text = "\n\n".join(history_parts)

    return (
        f"Translate the following structured proof into Lean 4 code.\n\n"
        f"--- STRUCTURED PROOF ---\n{proof_json}\n--- END ---\n\n"
        f"PREVIOUS ATTEMPTS AND THEIR RESULTS:\n\n{history_text}\n\n"
        f"Learn from the failures above. Do NOT repeat the same mistakes.\n"
        f"Produce ONLY the Lean 4 code. No explanation, no markdown fences.\n"
        f"Include all necessary imports at the top."
    )


# ---------------------------------------------------------------------------
# Goedel-Prover compact prompt format
# ---------------------------------------------------------------------------

def _proof_to_nl(proof: StructuredProof) -> str:
    """Convert a StructuredProof to compact NL text for Goedel's prompt format."""
    parts = [f"**Statement**: {proof.goal_statement}"]
    parts.append(f"**Strategy**: {proof.strategy}")

    if proof.assumptions:
        parts.append("**Assumptions**:")
        for a in proof.assumptions:
            hint = f" : {a.lean_type_hint}" if a.lean_type_hint else ""
            parts.append(f"- {a.name}{hint}: {a.statement}")

    parts.append("**Proof**:")
    for step in proof.steps:
        hint = f" (by {step.lean_tactic_hint})" if step.lean_tactic_hint else ""
        parts.append(f"{step.step_number}. {step.description}{hint}")

    if proof.dependencies:
        parts.append("**Dependencies**:")
        for d in proof.dependencies:
            parts.append(f"- {d.name}: {d.statement}")

    return "\n".join(parts)


def _build_goedel_prompt(proof: StructuredProof) -> str:
    """Build a compact prompt matching Goedel-Prover's training format."""
    nl = _proof_to_nl(proof)
    return (
        f"### Instruction\n"
        f"Translate the following mathematical proof into Lean 4 code with Mathlib imports.\n\n"
        f"### Natural Language Proof\n{nl}\n\n"
        f"### Lean 4 Code\n"
    )


def _build_goedel_retry_prompt(
    proof: StructuredProof,
    history: list[TranslationTriple],
) -> str:
    """Build a Goedel retry prompt: compact NL + last failed attempt + error."""
    nl = _proof_to_nl(proof)
    # Only include the most recent failed attempt (context is limited)
    last = history[-1]
    return (
        f"### Instruction\n"
        f"Translate the following mathematical proof into Lean 4 code with Mathlib imports.\n"
        f"A previous attempt failed. Fix the errors.\n\n"
        f"### Natural Language Proof\n{nl}\n\n"
        f"### Previous Attempt (FAILED)\n{last.lean_code}\n\n"
        f"### Compiler Error\n{last.compiler_output[:500]}\n\n"
        f"### Lean 4 Code\n"
    )


def _is_goedel_model(model: str) -> bool:
    """Check if a model string refers to a Goedel-Prover variant."""
    return "goedel" in model.lower() or "Goedel" in model


def _extract_lean_code(response: str) -> str:
    """Extract Lean code from response, stripping markdown fences and headers."""
    text = response.strip()

    # Strip markdown code fences
    if text.startswith("```"):
        lines = text.split("\n")
        lines = [l for l in lines[1:] if not l.strip() == "```"]
        text = "\n".join(lines)

    # Strip Goedel-style markdown headers (### Lean 4 Proof, ### Lean 4 Code, etc.)
    lines = text.split("\n")
    lines = [l for l in lines if not l.strip().startswith("### ")]

    # Strip leading comment lines that aren't Lean code
    while lines and lines[0].strip().startswith("--") and "import" not in lines[0]:
        lines.pop(0)

    return "\n".join(lines).strip()


# ---------------------------------------------------------------------------
# Main agent
# ---------------------------------------------------------------------------

class TranslatorAgent:
    """Agent 6: Translate structured proofs to Lean 4 with escalation.

    5 attempts with DeepSeek → 5 attempts with Opus → flag for human.
    Each attempt carries full history of previous failures.
    Every attempt produces a training triple.

    The optional PromptTuner injects lessons learned from past failures
    into the system prompt, so models avoid repeating common mistakes.
    """

    def __init__(
        self,
        compiler: LeanCompiler,
        tier1_model: str = TIER1_MODEL,
        tier2_model: str = TIER2_MODEL,
        tuner: PromptTuner | None = None,
    ):
        self.compiler = compiler
        self.tier1_model = tier1_model
        self.tier2_model = tier2_model
        self.tuner = tuner or PromptTuner()

    def translate(self, proof: StructuredProof) -> TranslationResult:
        """Translate a structured proof to Lean 4.

        Tries tier 1 (Goedel-Prover), then tier 2 (Sonnet/Opus), then flags for human.
        """
        triples: list[TranslationTriple] = []

        # Tier 1: Goedel-Prover (compact prompt, smaller context)
        print(f"  [Agent 6] Tier 1: {self.tier1_model} "
              f"(up to {MAX_ATTEMPTS_TIER1} attempts)")
        result = self._try_tier(
            proof, self.tier1_model, MAX_ATTEMPTS_TIER1, triples,
            max_tokens=TIER1_MAX_TOKENS,
        )
        if result is not None:
            return result

        # Tier 2: Sonnet/Opus (full prompt with system instructions)
        print(f"  [Agent 6] Tier 1 exhausted. Escalating to Tier 2: {self.tier2_model} "
              f"(up to {MAX_ATTEMPTS_TIER2} attempts)")
        result = self._try_tier(
            proof, self.tier2_model, MAX_ATTEMPTS_TIER2, triples,
            max_tokens=TIER2_MAX_TOKENS,
        )
        if result is not None:
            return result

        # Both tiers exhausted
        print(f"  [Agent 6] Both tiers exhausted. Flagging for human attention.")
        return TranslationResult(
            outcome=TranslationOutcome.NEEDS_HUMAN,
            lean_code=triples[-1].lean_code if triples else None,
            triples=triples,
            total_attempts=len(triples),
        )

    def _try_tier(
        self,
        proof: StructuredProof,
        model: str,
        max_attempts: int,
        triples: list[TranslationTriple],
        max_tokens: int = 8192,
    ) -> TranslationResult | None:
        """Try up to max_attempts with a given model. Returns result on success, None to escalate."""
        use_goedel = _is_goedel_model(model)

        for i in range(max_attempts):
            attempt_num = len(triples) + 1

            if use_goedel:
                # Goedel: compact prompt matching its training format, no system prompt
                if not triples:
                    prompt = _build_goedel_prompt(proof)
                else:
                    prompt = _build_goedel_retry_prompt(proof, triples)
                system = ""
            else:
                # Cloud models: full system prompt with tuner lessons
                base_system = PROMPT_PATH.read_text() if PROMPT_PATH.exists() else ""
                current_errors = [
                    t.compiler_output for t in triples if not t.compiled and t.compiler_output
                ]
                lessons = self.tuner.get_lessons(current_errors if current_errors else None)
                system = f"{base_system}\n\n{lessons}" if lessons else base_system

                if not triples:
                    prompt = _build_initial_prompt(proof)
                else:
                    prompt = _build_retry_prompt(proof, triples)

            # Call LLM
            response = complete(model, prompt, system=system, max_tokens=max_tokens)
            lean_code = _extract_lean_code(response)

            # Reject empty or trivially vacuous code
            if not lean_code or not any(
                kw in lean_code for kw in ("theorem ", "lemma ", "def ", "instance ")
            ):
                compiled = False
                compiler_output = (
                    "error: empty or vacuous code — must contain a theorem/lemma/def declaration"
                )
            else:
                # Compile
                compiled, compiler_output = self.compiler.compile(lean_code)

            # Record triple
            triple = TranslationTriple(
                structured_proof=proof,
                lean_code=lean_code,
                compiler_output=compiler_output,
                compiled=compiled,
                model=model,
                attempt_number=attempt_num,
            )
            triples.append(triple)

            if compiled:
                print(f"    Attempt {attempt_num}: SUCCESS")
                return TranslationResult(
                    outcome=TranslationOutcome.SUCCESS,
                    lean_code=lean_code,
                    triples=triples,
                    total_attempts=len(triples),
                )
            else:
                # Truncate long compiler output for display
                short_err = compiler_output[:120].replace("\n", " ")
                print(f"    Attempt {attempt_num}: FAIL — {short_err}...")

        return None  # signal to escalate
