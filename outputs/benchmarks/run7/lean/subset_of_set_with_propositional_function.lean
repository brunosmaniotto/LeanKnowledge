import Mathlib

variable {α : Type*}

theorem subset_of_sep (S : Set α) (P : α → Prop) : {x ∈ S | P x} ⊆ S := by
  intro x hx
  exact hx.1