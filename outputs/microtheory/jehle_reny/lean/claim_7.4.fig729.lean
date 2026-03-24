import Mathlib

structure Player2Strategy where
  left : ℝ
  right : ℝ
  h_left : 0 ≤ left
  h_right : 0 ≤ right
  h_sum : left + right = 1

noncomputable def b0 : Player2Strategy :=
  { left := 1/3
    right := 2/3
    h_left := by norm_num
    h_right := by norm_num
    h_sum := by norm_num }