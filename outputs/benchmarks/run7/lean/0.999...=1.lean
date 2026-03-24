import Mathlib

theorem zero_point_nine_repeating_eq_one : (∑' n : ℕ, 9/10 * ((1 : ℝ)/10) ^ n) = 1 := by
  rw [tsum_mul_left, tsum_geometric_of_norm_lt_one (by norm_num : ‖(1 : ℝ)/10‖ < 1)]
  norm_num