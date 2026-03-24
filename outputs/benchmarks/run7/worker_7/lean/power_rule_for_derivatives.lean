import Mathlib

theorem power_rule (n : ℝ) (x : ℝ) (h : x ≠ 0 ∨ 1 ≤ n) : HasDerivAt (fun x : ℝ => x ^ n) (n * x ^ (n - 1)) x :=
  Real.hasDerivAt_rpow_const h