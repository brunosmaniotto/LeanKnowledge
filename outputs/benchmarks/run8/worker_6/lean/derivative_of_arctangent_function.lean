import Mathlib

open Real

theorem deriv_arctan_eq (x : ℝ) : deriv arctan x = 1 / (1 + x^2) :=
  (hasDerivAt_arctan x).deriv