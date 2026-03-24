import Mathlib
open Set

/-- A binary relation R is a relation on the set S if R ⊆ S × S. -/
def IsRelationOn {α : Type*} (R : Set (α × α)) (S : Set α) : Prop :=
  R ⊆ S ×ˢ S