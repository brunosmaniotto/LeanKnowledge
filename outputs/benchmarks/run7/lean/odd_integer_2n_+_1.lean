import Mathlib

theorem odd_exists_unique_int (m : ℤ) (h : Odd m) : ∃! n : ℤ, 2 * n + 1 = m := by
  rcases h with ⟨k, hk⟩
  refine ⟨k, ?_, ?_⟩
  · rw [hk]
  · intro n hn
    linarith