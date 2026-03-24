import Mathlib

open Set Topology

variable {E : Type*} [TopologicalSpace E]

def MWG.IsInteriorMax (f : E → ℝ) (D : Set E) (x : E) : Prop :=
  x ∈ interior D ∧ IsLocalMaxOn f D x