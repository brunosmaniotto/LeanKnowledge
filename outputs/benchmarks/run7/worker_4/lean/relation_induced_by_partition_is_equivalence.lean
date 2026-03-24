import Mathlib.Data.Setoid.Partition

open Set Setoid

variable {α : Type u}

/-- The relation induced by a partition: x and y are related if they lie in the same block. -/
def inducedRelation (c : Set (Set α)) (x y : α) : Prop := ∃ s ∈ c, x ∈ s ∧ y ∈ s