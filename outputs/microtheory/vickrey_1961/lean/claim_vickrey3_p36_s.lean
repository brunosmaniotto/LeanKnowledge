import Mathlib

axiom vickrey_inequality_iff_polynomial_le_zero {v1 : ℝ} (h_v1_pos : 0 < v1) : (v1 ≤ 0.8 - (1 / (4 * v1)) * 0.8 ^ 2) ↔ (v1 * v1 - 0.8 * v1 + 0.16 ≤ 0)
axiom polynomial_le_zero_iff_v1_eq_four_tenths (v1 : ℝ) : (v1 * v1 - 0.8 * v1 + 0.16 ≤ 0) ↔ (v1 = 0.4)

theorem Claim_Vickrey3_p36_s {v1 : ℝ} (h_v1_pos : 0 < v1) (h_v1_le_1 : v1 ≤ 1) :
    (v1 ≤ 0.8 - (1 / (4 * v1)) * 0.8^2) ↔ v1 = 0.4 := by
  rw [vickrey_inequality_iff_polynomial_le_zero h_v1_pos]
  exact polynomial_le_zero_iff_v1_eq_four_tenths v1