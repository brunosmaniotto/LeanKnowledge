import Mathlib

/-- Proof by contradiction (reductio ad absurdum) for an implication A ⇒ B:
    if assuming A and ¬B leads to a contradiction, then A → B holds.
    This relies on the fact that if A ⇒ ∼B is false, then A ⇒ B must be true. -/
def proofByContradiction (A B : Prop) : Prop :=
  (A → ¬B → False) → (A → B)