import Mathlib

theorem deriv_exp_at (x : ℝ) : deriv Real.exp x = Real.exp x := by
  rw [Real.deriv_exp]