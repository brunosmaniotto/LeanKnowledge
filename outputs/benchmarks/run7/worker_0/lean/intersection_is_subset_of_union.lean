import Mathlib

variable {α : Type*} (S T : Set α)

theorem inter_subset_union : S ∩ T ⊆ S ∪ T := by
  intro x hx
  exact Or.inl hx.left