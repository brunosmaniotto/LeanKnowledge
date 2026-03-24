import Mathlib

open Set

theorem symmetric_difference_of_equal_sets {α : Type*} (S T : Set α) : 
  S = T ↔ (S \ T) ∪ (T \ S) = ∅ := by
  rw [← symmDiff_eq_empty]
  rfl