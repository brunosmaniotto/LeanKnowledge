import Mathlib

open Real

theorem zero_point_nine_repeating_eq_one : (∑' n : ℕ, (9 : ℝ)/10 * ((1 : ℝ)/10) ^ n) = 1 := by
  have h_norm : ‖(1 : ℝ)/10‖ < 1 := by norm_num
  calc
    (∑' n : ℕ, (9 : ℝ)/10 * ((1 : ℝ)/10) ^ n) = (9/10) * (∑' n : ℕ, ((1 : ℝ)/10) ^ n) := by
      rw [tsum_mul_left]
    _ = (9/10) * ((1 - (1/10))⁻¹) := by rw [tsum_geometric_of_norm_lt_one h_norm]
    _ = (9/10) * (10/9) := by norm_num
    _ = 1 := by norm_num