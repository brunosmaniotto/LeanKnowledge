import Mathlib

noncomputable def arrowPrattAbsoluteRiskAversion (u : ℝ → ℝ) (u'' u' : ℝ → ℝ) (x : ℝ) : ℝ :=
  -(u'' x) / (u' x)