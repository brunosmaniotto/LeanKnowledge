import Mathlib

/-- The behavioural assumption: the consumer seeks x* ∈ B such that x* ≿ x
    for all x ∈ B. This is the "most preferred" or "optimal choice" predicate. -/
def IsOptimalChoice {X : Type*} (pref : X → X → Prop) (B : Set X) (x_star : X) : Prop :=
  x_star ∈ B ∧ ∀ x ∈ B, pref x_star x