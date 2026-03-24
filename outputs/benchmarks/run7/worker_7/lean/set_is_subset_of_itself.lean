import Mathlib

theorem set_subset_self (S : Set α) : S ⊆ S := by
  intro x hx
  exact hx