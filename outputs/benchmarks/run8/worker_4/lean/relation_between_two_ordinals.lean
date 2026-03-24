import Mathlib.SetTheory.Ordinal.Basic

open Ordinal

/-- For any two ordinals, one is less than or equal to the other. -/
theorem ordinal_subset_or_subset (S T : Ordinal) : S ≤ T ∨ T ≤ S :=
  le_total S T