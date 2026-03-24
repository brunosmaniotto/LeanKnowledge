import Mathlib

theorem set_diff_empty (S : Set α) : S \ ∅ = S := by
  ext x
  constructor
  · intro h
    exact h.1
  · intro h
    exact ⟨h, by simp⟩