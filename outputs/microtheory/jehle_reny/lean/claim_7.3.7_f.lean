import Mathlib
set_option linter.unusedVariables false

theorem claim_7_3_7_f_reach_zero (p1_left : ℝ) (hp1 : p1_left = 1)
    (p2_cond : ℝ) (hp2 : 0 ≤ p2_cond) (hp2' : p2_cond ≤ 1) :
    (1 - p1_left) * p2_cond = 0 := by
  simp [hp1]