import Mathlib

/-- The Arrow–Pratt measure of absolute risk aversion: Rₐ(w) = −u″(w) / u′(w). -/
noncomputable def arrowPrattAbsoluteRiskAversion (u : ℝ → ℝ) (w : ℝ) : ℝ :=
  -(deriv (deriv u) w) / (deriv u w)