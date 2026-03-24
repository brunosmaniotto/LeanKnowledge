import Mathlib

theorem square_of_difference (x y : ℝ) : (x - y) ^ 2 = x ^ 2 - 2 * x * y + y ^ 2 := by
  ring