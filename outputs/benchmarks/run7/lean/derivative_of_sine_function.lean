import Mathlib

open Real

theorem derivative_of_sin (x : ℝ) : deriv sin x = cos x :=
  (hasDerivAt_sin x).deriv