import Mathlib

variable {α : Type*} (S T : Set α)

theorem subset_union_left : S ⊆ S ∪ T := by
  intro x hx
  exact Or.inl hx