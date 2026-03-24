import Mathlib

open MeasureTheory

/-- A measure μ first-order stochastically dominates ν if, for every nondecreasing
    function u : ℝ → ℝ, the integral of u with respect to μ is at least that
    with respect to ν. (MWG Definition 6.D.1) -/
def FirstOrderStochDom (μ ν : Measure ℝ) : Prop :=
  ∀ u : ℝ → ℝ, Monotone u → ∫ x, u x ∂μ ≥ ∫ x, u x ∂ν