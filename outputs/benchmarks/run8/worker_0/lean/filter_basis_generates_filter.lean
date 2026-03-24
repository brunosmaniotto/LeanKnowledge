import Mathlib

variable {S : Type _}

/-- The set of all subsets of `S` that contain some set from `B`. -/
def F (B : Set (Set S)) : Set (Set S) := {V | ∃ U ∈ B, U ⊆ V}