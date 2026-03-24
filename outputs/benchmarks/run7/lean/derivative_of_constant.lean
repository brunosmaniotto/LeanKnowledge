import Mathlib

theorem derivative_of_constant (c x : ℝ) : deriv (fun y => c) x = 0 := by
  simp