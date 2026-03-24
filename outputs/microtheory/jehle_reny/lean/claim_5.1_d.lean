import Mathlib

variable {I Allocation : Type*}

def ParetoEfficient (feasible : Set Allocation) (u : I → Allocation → ℝ)
    (x : Allocation) : Prop :=
  x ∈ feasible ∧
  ¬∃ y ∈ feasible, (∀ i, u i x ≤ u i y) ∧ (∃ i, u i x < u i y)