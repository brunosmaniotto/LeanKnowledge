import Mathlib
open MeasureTheory Set Topology

/-- When income elasticity of demand η(y) is independent of price,
    the consumer surplus CS and compensating variation CV satisfy:
    −CS = ∫_{y⁰}^{CV+y⁰} exp(−∫_{y⁰}^{ζ} η(ξ)/ξ dξ) dζ. -/
def Exercise_4_18_relation
    (q : ℝ → ℝ → ℝ)          -- demand q(p, y)
    (η : ℝ → ℝ)               -- income elasticity η(y), independent of price
    (y₀ : ℝ)                  -- initial income
    (CS : ℝ)                  -- consumer surplus
    (CV : ℝ)                  -- compensating variation
    : Prop :=
  (∀ p y, y ≠ 0 → q p y ≠ 0 →
    η y = (deriv (q p) y) * y / (q p y)) ∧
  -CS = ∫ ζ in y₀..(CV + y₀),
    Real.exp (- ∫ ξ in y₀..ζ, η ξ / ξ)