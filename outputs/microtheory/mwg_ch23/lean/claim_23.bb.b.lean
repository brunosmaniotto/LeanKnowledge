import Mathlib

variable {N X : Type*} [Fintype N] [DecidableEq N]

def ParetoOptimal (u : N → X → ℝ) (x : X) : Prop :=
  ¬∃ y : X, (∀ i, u i y ≥ u i x) ∧ (∃ i, u i y > u i x)