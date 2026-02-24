"""Tier 2: Resolver Agent — heavy-model compile-repair loop for axiomatized theorems.

Takes theorems that failed Tier 1 formalization (now axioms in Axioms.lean) and
attempts to prove them using a heavier reasoning model with more iterations.
"""

from collections.abc import Callable
from pathlib import Path

from ..schemas import (
    BacklogEntry,
    LeanCode,
    ResolverResult,
    TheoremInput,
)
from ..claude_client import call_claude
from ..lean.compiler import LeanCompiler
from ..lean.errors import is_fundamental_failure

PROMPT_PATH = Path(__file__).resolve().parents[3] / "prompts" / "resolver.md"

RESOLVER_MAX_ITERATIONS = 10
RESOLVER_MAX_REVISIONS = 3


class ResolverAgent:
    def __init__(self, compiler: LeanCompiler, call_fn: Callable | None = None):
        self.compiler = compiler
        self.call_fn = call_fn or call_claude

    def resolve(self, entry: BacklogEntry) -> ResolverResult:
        """Attempt to prove an axiomatized theorem with heavy-model reasoning."""
        theorem = TheoremInput(
            name=entry.item.id,
            statement=entry.item.statement,
            domain=entry.domain,
            source=entry.source,
        )

        # Phase 1: Generate initial Lean proof (combined proof+translation)
        print(f"  [resolver] Generating initial proof for {theorem.name}...")
        lean_code = self._generate_proof(theorem, entry.failure_reason)

        # Phase 2: Compile-repair loop
        return self._verify_loop(lean_code, theorem, entry)

    def _generate_proof(self, theorem: TheoremInput, failure_reason: str | None) -> LeanCode:
        """Generate Lean 4 proof code using the heavy model."""
        system = PROMPT_PATH.read_text()
        prompt = (
            f"Theorem: {theorem.name}\n"
            f"Statement: {theorem.statement}\n"
            f"Domain: {theorem.domain.value}\n"
        )
        if theorem.source:
            prompt += f"Source: {theorem.source}\n"
        if failure_reason:
            prompt += (
                f"\nPrevious attempt failed with: {failure_reason}\n"
                f"Use a different approach.\n"
            )

        data = self.call_fn(prompt, system=system, schema=LeanCode, caller="resolver.generate")
        return LeanCode.model_validate(data)

    def _repair(self, lean_code: LeanCode, error_text: str, theorem: TheoremInput) -> LeanCode:
        """Repair Lean code using the heavy model."""
        system = PROMPT_PATH.read_text()
        prompt = (
            f"The following Lean 4 code failed to compile.\n\n"
            f"Code:\n```lean\n{lean_code.code}\n```\n\n"
            f"Compiler errors:\n{error_text}\n\n"
            f"Original theorem: {theorem.name}\n"
            f"Statement: {theorem.statement}\n\n"
            f"Please fix the Lean code."
        )

        data = self.call_fn(prompt, system=system, schema=LeanCode, caller="resolver.repair")
        return LeanCode.model_validate(data)

    def _revise(self, theorem: TheoremInput, error_summary: str) -> LeanCode:
        """Generate a completely new proof approach after fundamental failure."""
        system = PROMPT_PATH.read_text()
        prompt = (
            f"Theorem: {theorem.name}\n"
            f"Statement: {theorem.statement}\n"
            f"Domain: {theorem.domain.value}\n\n"
            f"Multiple repair attempts failed. Error summary:\n{error_summary}\n\n"
            f"The previous approach is fundamentally flawed. "
            f"Generate a COMPLETELY DIFFERENT proof strategy from scratch."
        )

        data = self.call_fn(prompt, system=system, schema=LeanCode, caller="resolver.revise")
        return LeanCode.model_validate(data)

    def _verify_loop(
        self, lean_code: LeanCode, theorem: TheoremInput, entry: BacklogEntry
    ) -> ResolverResult:
        """Compile-repair loop with escalation to full proof revision."""
        current_code = lean_code
        total_iterations = 0
        proof_revisions = 0

        for iteration in range(RESOLVER_MAX_ITERATIONS):
            total_iterations = iteration + 1
            success, errors = self.compiler.compile(current_code)

            if success:
                print(f"  [resolver] Success at iteration {total_iterations}")
                return ResolverResult(
                    success=True,
                    item_id=entry.item.id,
                    lean_code=current_code.code,
                    iterations=total_iterations,
                    proof_revisions=proof_revisions,
                )

            # Check for fundamental failure → revise entire proof
            if is_fundamental_failure(errors, iteration, RESOLVER_MAX_ITERATIONS):
                if proof_revisions >= RESOLVER_MAX_REVISIONS:
                    break  # Exhausted revisions

                error_summary = "\n".join(e.message for e in errors)
                print(
                    f"  [resolver] Fundamental failure at iteration {total_iterations}, "
                    f"revision {proof_revisions + 1}/{RESOLVER_MAX_REVISIONS}"
                )
                current_code = self._revise(theorem, error_summary)
                proof_revisions += 1
                continue

            # Local repair
            error_text = "\n".join(
                f"Line {e.line}: [{e.category.value}] {e.message}" for e in errors
            )
            print(
                f"  [resolver] Iteration {total_iterations}: "
                f"{len(errors)} error(s), attempting repair"
            )
            current_code = self._repair(current_code, error_text, theorem)

        # Exhausted iterations
        _, final_errors = self.compiler.compile(current_code)
        print(f"  [resolver] Failed after {total_iterations} iterations, {proof_revisions} revisions")
        return ResolverResult(
            success=False,
            item_id=entry.item.id,
            lean_code=current_code.code,
            iterations=total_iterations,
            proof_revisions=proof_revisions,
            errors=final_errors,
        )
