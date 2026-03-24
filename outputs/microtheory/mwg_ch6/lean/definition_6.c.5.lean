import Mathlib

noncomputable def coeffRelativeRiskAversion (u : ℝ → ℝ) (x : ℝ) : ℝ :=
  -(x * deriv (deriv u) x / deriv u x)