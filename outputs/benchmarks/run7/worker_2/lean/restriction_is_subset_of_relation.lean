import Mathlib

open Set

variable {S T : Type} (R : Set (S × T)) (X : Set S)

/-- Restriction of relation R to set X. -/
def restrict : Set (S × T) := R ∩ (X ×ˢ (Set.univ : Set T))