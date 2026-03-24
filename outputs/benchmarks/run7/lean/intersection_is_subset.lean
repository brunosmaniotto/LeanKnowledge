import Mathlib

variable {α : Type*} (S T : Set α)

theorem inter_subset_left : S ∩ T ⊆ S := by
  intro x hx
  exact hx.left