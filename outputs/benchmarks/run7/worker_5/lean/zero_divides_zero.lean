import Mathlib

theorem zero_divides_only_zero (n : ℤ) (h : 0 ∣ n) : n = 0 := by
  rcases h with ⟨k, hk⟩
  simp at hk
  exact hk