import Mathlib

theorem deriv_arcsin (x : ℝ) (hx1 : -1 < x) (hx2 : x < 1) :
    deriv Real.arcsin x = 1 / Real.sqrt (1 - x ^ 2) := by
  have h1 : x ≠ -1 := by linarith
  have h2 : x ≠ 1 := by linarith
  exact (Real.hasDerivAt_arcsin h1 h2).deriv