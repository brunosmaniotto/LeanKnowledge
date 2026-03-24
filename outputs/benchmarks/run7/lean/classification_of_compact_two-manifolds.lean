import Mathlib

open Real

theorem add_sq_le' (a b : ℝ) : (a + b) ^ 2 ≤ 2 * (a ^ 2 + b ^ 2) := by
  have h : (a - b) ^ 2 ≥ 0 := pow_two_nonneg _
  linarith [add_sq a b]