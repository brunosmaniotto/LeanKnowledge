import Mathlib

theorem derivative_sin (x : ℝ) : HasDerivAt Real.sin (Real.cos x) x :=
  Real.hasDerivAt_sin x