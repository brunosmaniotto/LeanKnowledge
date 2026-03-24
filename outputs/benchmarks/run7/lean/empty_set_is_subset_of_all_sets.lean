import Mathlib

variable {α : Type}

theorem empty_set_subset_all_sets (S : Set α) : (∅ : Set α) ⊆ S := by
  intro x h
  simp at h