import Mathlib

open Set

variable {X : Type*} (S : Set (Set X))

/-- The synthetic basis formed from a synthetic sub-basis `S`. -/
def B : Set (Set X) :=
  { b | ∃ (F : Set (Set X)) (hF : F ⊆ S) (hfin : Set.Finite F), b = ⋂₀ F }