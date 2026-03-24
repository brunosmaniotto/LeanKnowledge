import Mathlib

theorem exercise_4_27
    (ε : ℝ)
    (hε : ε > 1) :
    ε / (ε - 1) > 1 := by
  have hε_sub : (0 : ℝ) < ε - 1 := by linarith
  rw [gt_iff_lt, one_lt_div hε_sub]
  linarith