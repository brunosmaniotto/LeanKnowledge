import Mathlib
set_option linter.unusedVariables false

theorem Claim_7_3_7_a (p_x p_y : ℝ) (h_sum : p_x + p_y = 1) :
    1 * p_x + 1 * p_y < 2 * p_x + 2 * p_y := by
  -- Simplify both sides using the condition p_x + p_y = 1
  have h_left : 1 * p_x + 1 * p_y = p_x + p_y := by ring
  have h_right : 2 * p_x + 2 * p_y = 2 * (p_x + p_y) := by ring
  rw [h_left, h_right, h_sum]
  norm_num