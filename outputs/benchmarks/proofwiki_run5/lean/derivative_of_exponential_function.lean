import Mathlib

theorem derivative_of_exp (x : ℝ) : deriv Real.exp x = Real.exp x :=
  (Real.hasDerivAt_exp x).deriv