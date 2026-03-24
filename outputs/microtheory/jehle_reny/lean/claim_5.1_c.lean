import Mathlib

variable {I : Type*} [Fintype I] [DecidableEq I] {X : Type*}

def ParetoEfficient (u : I → X → ℝ) (F : Set X) (x : X) : Prop :=
  x ∈ F ∧ ¬∃ y ∈ F, (∀ i, u i y ≥ u i x) ∧ (∃ i, u i y > u i x)