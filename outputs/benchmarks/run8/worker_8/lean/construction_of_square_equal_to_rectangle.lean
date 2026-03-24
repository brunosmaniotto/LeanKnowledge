import Mathlib

theorem square_eq_rectangle (a : ℝ) : a * (a - (a / 2) * (Real.sqrt 5 - 1)) = ((a / 2) * (Real.sqrt 5 - 1)) ^ 2 := by
  have h : (Real.sqrt 5) ^ 2 = 5 := Real.sq_sqrt (by norm_num)
  ring_nf
  rw [h]
  ring