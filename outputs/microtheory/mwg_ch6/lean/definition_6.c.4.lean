import Mathlib

open Set

/-- The Arrow–Pratt coefficient of absolute risk aversion: rₐ(x, u) = −u″(x) / u′(x). -/
noncomputable def absoluteRiskAversion (u : ℝ → ℝ) (x : ℝ) : ℝ :=
  -(deriv (deriv u) x) / (deriv u x)

/-- A Bernoulli utility function exhibits decreasing absolute risk aversion (DARA)
    if rₐ(x, u) is a decreasing function of x. -/
def DecreasingAbsoluteRiskAversion (u : ℝ → ℝ) : Prop :=
  ∀ x y : ℝ, x < y → absoluteRiskAversion u y ≤ absoluteRiskAversion u x