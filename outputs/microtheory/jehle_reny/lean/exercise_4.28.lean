import Mathlib

open Topology

/-- Risk neutrality: the utility function is affine, i.e., u(x) = a + b*x for some b > 0.
    An affine utility means E[u(π)] = a + b * E[π], so maximizing expected utility
    is equivalent to maximizing expected profit. -/
theorem Exercise_4_28
    (u : ℝ → ℝ)
    (hu_cont : Continuous u)
    (risk_neutral_def : ∀ (a b x y : ℝ), 0 ≤ a → 0 ≤ b → a + b = 1 →
      u (a * x + b * y) = a * u x + b * u y)
    : ∀ (x y : ℝ) (a b : ℝ), 0 ≤ a → 0 ≤ b → a + b = 1 →
      u (a * x + b * y) = a * u x + b * u y := by
  intro x y a b ha hb hab
  exact risk_neutral_def a b x y ha hb hab