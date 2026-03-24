import Mathlib

open Real

theorem derivative_cosine (x : ℝ) : deriv cos x = -sin x :=
  (hasDerivAt_cos x).deriv