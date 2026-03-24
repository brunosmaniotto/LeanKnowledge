import Mathlib

def IsParetoImprovement {I : Type*} {X : Type*} (u : I → X → ℝ) (x x' : X) : Prop :=
  (∀ i, u i x ≤ u i x') ∧ (∃ i, u i x < u i x')