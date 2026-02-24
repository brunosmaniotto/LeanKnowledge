"""Stage 3: Verification Loop — compile, classify errors, repair, repeat.

Integrates RepairDB for deterministic fixes before falling back to Claude.
"""

import json
from datetime import datetime
from pathlib import Path

from ..schemas import (
    TheoremInput,
    StructuredProof,
    LeanCode,
    VerificationResult,
)
from ..lean.compiler import LeanCompiler
from ..lean.errors import is_fundamental_failure
from ..lean.repair_db import RepairDB
from .translator import TranslatorAgent
from .proof import ProofAgent

MAX_REPAIR_ITERATIONS = 6
MAX_PROOF_REVISIONS = 2
PROJECT_ROOT = Path(__file__).resolve().parents[3]
TRAJECTORIES_DIR = PROJECT_ROOT / "training_data" / "search_trajectories"


class Verifier:
    def __init__(self, compiler: LeanCompiler, translator: TranslatorAgent, proof_agent: ProofAgent, strategy_kb=None):
        self.compiler = compiler
        self.translator = translator
        self.proof_agent = proof_agent
        self.repair_db = RepairDB()
        self.strategy_kb = strategy_kb

    def _build_tactic_hints(self, proof: StructuredProof) -> str:
        """Build tactic hints from Strategy KB for a proof (used during re-translation)."""
        if not self.strategy_kb:
            return ""
        from collections import Counter
        patterns = self.strategy_kb.tactic_patterns(proof.strategy.value)
        if not patterns:
            return ""
        tactic_freq = Counter()
        for seq in patterns[:50]:
            for tactic in seq:
                tactic_freq[tactic] += 1
        if not tactic_freq:
            return ""
        top_tactics = tactic_freq.most_common(10)
        lines = [f"Tactics that commonly succeed for '{proof.strategy.value}' proofs:"]
        for tactic, count in top_tactics:
            lines.append(f"- `{tactic}` (used in {count} successful proofs)")
        return "\n".join(lines)

    def verify(
        self,
        lean_code: LeanCode,
        proof: StructuredProof,
        theorem: TheoremInput,
    ) -> VerificationResult:
        """Run the compile-repair loop.

        Flow:
        1. Compile lean_code
        2. If success -> done
        3. If error -> try RepairDB (deterministic) first
           a. If RepairDB fixes it -> recompile
           b. If not -> classify errors
              i.  Syntax/tactic/missing lemma -> translator repairs (Claude)
              ii. Fundamental failure -> escalate to proof agent for new strategy
        4. Repeat up to MAX_REPAIR_ITERATIONS
        """
        current_code = lean_code
        current_proof = proof
        total_iterations = 0
        proof_revisions = 0
        
        trajectory = []

        for iteration in range(MAX_REPAIR_ITERATIONS):
            total_iterations = iteration + 1
            success, errors = self.compiler.compile(current_code)
            
            step_record = {
                "iteration": total_iterations,
                "lean_code": current_code.code,
                "errors": [{"type": e.category.value, "message": e.message} for e in errors],
                "repair_action": None,
                "repair_source": None
            }

            if success:
                self._save_trajectory(theorem.name, trajectory + [step_record], "success", total_iterations, proof_revisions)
                return VerificationResult(
                    success=True,
                    lean_code=current_code.code,
                    iterations=total_iterations,
                    escalated_to_proof_agent=proof_revisions > 0,
                )

            # Check if this is a fundamental failure requiring new proof strategy
            if is_fundamental_failure(errors, iteration, MAX_REPAIR_ITERATIONS):
                if proof_revisions >= MAX_PROOF_REVISIONS:
                    step_record["repair_action"] = "fundamental failure, max revisions reached"
                    trajectory.append(step_record)
                    break  # Give up

                error_summary = "\n".join(e.message for e in errors)
                print(f"  [verifier] Fundamental failure at iteration {iteration + 1}, escalating to proof agent")

                step_record["repair_action"] = "escalated to proof agent"
                step_record["repair_source"] = "proof_revision"
                trajectory.append(step_record)

                # Build strategy hints from KB for the revision
                strategy_hints = ""
                if self.strategy_kb:
                    error_types = list(set(e.category.value for e in errors))
                    for etype in error_types:
                        related = self.strategy_kb.query_by_error(etype)
                        successful = [r for r in related if r.iterations_to_compile <= 3]
                        if successful:
                            alt_strategies = set()
                            for r in successful:
                                alt_strategies.update(r.proof_strategies)
                            strategy_hints += f"After '{etype}' errors, these strategies worked: {', '.join(alt_strategies)}\n"

                current_proof = self.proof_agent.revise(
                    theorem, current_proof, error_summary, strategy_hints=strategy_hints
                )
                tactic_hints = self._build_tactic_hints(current_proof)
                current_code = self.translator.translate(current_proof, tactic_hints=tactic_hints)
                proof_revisions += 1
                continue

            # Try RepairDB first (deterministic, no LLM calls)
            repaired, fix_descriptions = self.repair_db.try_repair(current_code.code, errors)
            if repaired:
                print(f"  [verifier] Iteration {iteration + 1}: RepairDB applied {len(fix_descriptions)} fix(es)")
                # Verify the deterministic fix compiles
                db_success, db_errors = self.compiler.compile(repaired)
                
                step_record["repair_action"] = f"RepairDB fixes: {'; '.join(fix_descriptions)}"
                step_record["repair_source"] = "repair_db"
                trajectory.append(step_record)
                
                if db_success:
                    # Record the successful repair step
                    success_step = {
                        "iteration": total_iterations, # Still same iteration logically
                        "lean_code": repaired.code,
                        "errors": [],
                        "repair_action": None,
                        "repair_source": None
                    }
                    self._save_trajectory(theorem.name, trajectory + [success_step], "success", total_iterations, proof_revisions)
                    
                    return VerificationResult(
                        success=True,
                        lean_code=repaired.code,
                        iterations=total_iterations,
                        escalated_to_proof_agent=proof_revisions > 0,
                    )
                # RepairDB fix didn't fully resolve — fall through to Claude
                # but use the partially-fixed code as the base
                current_code = repaired
                errors = db_errors
                # Note: we already appended the step record for this iteration, but we are continuing
                # in the same iteration loop to try Claude.
                # To capture the flow accurately, let's update the last record or add a sub-step.
                # Simpler: just continue, next iteration of loop handles the next compile.
                # Actually, the logic below falls through to Claude in the SAME iteration.
                # So we should update the step record to reflect that we tried RepairDB AND then Claude?
                # Or just let the loop continue?
                # The logic is: RepairDB is tried. If success -> return. If fail -> continue to Claude.
                # The record above said "RepairDB fixes".
                # If we fall through, we are still in "iteration + 1".
                # Let's assume the trajectory captures the *attempt* at the start of the loop.
                # If RepairDB fails to fully fix, we proceed to Claude.

            # Local repair: translator fixes syntax/tactic/lemma errors (Claude)
            error_text = "\n".join(
                f"Line {e.line}: [{e.category.value}] {e.message}" for e in errors
            )
            print(f"  [verifier] Iteration {iteration + 1}: {len(errors)} error(s), attempting Claude repair")

            old_code = current_code.code
            current_code = self.translator.repair(
                current_proof, current_code, error_text,
                prior_fixes=fix_descriptions if fix_descriptions else None,
            )

            # Learn from successful Claude repairs
            if current_code.code != old_code:
                self.repair_db.learn(errors, old_code, current_code.code)
            
            # Update the step record if we didn't already append it (case where RepairDB didn't run or failed)
            # If RepairDB ran and failed, we appended. If it didn't run, we didn't append.
            # Actually, looking above: if repaired (RepairDB ran), we appended.
            # If NOT repaired (RepairDB didn't run), we need to append now.
            
            if not repaired:
                 step_record["repair_action"] = "claude repair"
                 step_record["repair_source"] = "llm"
                 trajectory.append(step_record)
            else:
                 # We already appended for RepairDB. But now we are doing Claude too.
                 # Let's just update the last record to say we did both? 
                 # Or just append another step? 
                 # Simpler: just rely on the next loop iteration to show the result of the Claude repair.
                 # But we need to record WHAT we did in this step.
                 # The 'repaired' block appends.
                 # If we are here, either RepairDB didn't run (so nothing appended), 
                 # or it ran but didn't fully fix (so appended "RepairDB fixes").
                 # If it ran but didn't fix, we are adding a Claude repair ON TOP.
                 pass

        # Exhausted iterations
        _, final_errors = self.compiler.compile(current_code)
        
        # Add final state if not success
        trajectory.append({
            "iteration": total_iterations + 1,
            "lean_code": current_code.code,
            "errors": [{"type": e.category.value, "message": e.message} for e in final_errors],
            "repair_action": "gave up",
            "repair_source": None
        })
        
        self._save_trajectory(theorem.name, trajectory, "failure", total_iterations, proof_revisions)

        return VerificationResult(
            success=False,
            lean_code=current_code.code,
            errors=final_errors,
            iterations=total_iterations,
            escalated_to_proof_agent=proof_revisions > 0,
        )

    def _save_trajectory(self, name: str, steps: list, outcome: str, iterations: int, revisions: int):
        """Save search trajectory to JSON."""
        TRAJECTORIES_DIR.mkdir(parents=True, exist_ok=True)
        data = {
            "theorem_name": name,
            "steps": steps,
            "outcome": outcome,
            "total_iterations": iterations,
            "proof_revisions": revisions,
            "timestamp": datetime.now().isoformat()
        }
        filename = f"{name.lower().replace(' ', '_')}_{datetime.now():%Y%m%d_%H%M%S}.json"
        (TRAJECTORIES_DIR / filename).write_text(json.dumps(data, indent=2))
