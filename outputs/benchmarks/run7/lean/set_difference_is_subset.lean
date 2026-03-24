import Mathlib

variable {α : Type*}

theorem set_diff_subset (S T : Set α) : S \ T ⊆ S := by
  intro x hx
  exact hx.left