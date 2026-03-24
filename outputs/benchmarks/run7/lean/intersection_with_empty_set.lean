import Mathlib

variable {α : Type*}

theorem S_inter_empty (S : Set α) : S ∩ ∅ = ∅ := by
  ext x
  simp