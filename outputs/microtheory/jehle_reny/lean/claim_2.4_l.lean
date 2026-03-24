import Mathlib

theorem Claim_2_4_l :
    (0.6 : ℝ) * 10 + 0.4 * (-2) = 5.2 ∧ (4 : ℝ) < 5.2 := by
  constructor <;> norm_num