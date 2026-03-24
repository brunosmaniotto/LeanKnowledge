import Mathlib

open Real

theorem claim_5C_p (α β : ℝ) (hα : 0 < α) (hβ : 0 < β) (hIRS : 1 < α + β) :
    (2 : ℝ) ^ ((1 : ℝ) / (α + β)) < 2 := by
  have hab_pos : 0 < α + β := by linarith
  have h_exp_lt_one : 1 / (α + β) < 1 := by
    rw [div_lt_one hab_pos]
    linarith
  conv_rhs => rw [show (2 : ℝ) = (2 : ℝ) ^ (1 : ℝ) from (rpow_one 2).symm]
  exact rpow_lt_rpow_of_exponent_lt (by norm_num : (1 : ℝ) < 2) h_exp_lt_one