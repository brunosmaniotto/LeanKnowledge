import Mathlib

-- For natural numbers (truncated subtraction)
theorem Nat.add_sub_min_eq_max (a b : ℕ) : a + b - min a b = max a b := by
  by_cases h : a ≤ b
  · rw [max_eq_right h, min_eq_left h]
    omega
  · rw [max_eq_left (by omega), min_eq_right (by omega)]
    omega

-- For any linear ordered additive commutative group (ℤ, ℝ, ℚ, etc.)