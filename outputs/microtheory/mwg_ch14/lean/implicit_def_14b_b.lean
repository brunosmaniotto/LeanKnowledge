import Mathlib
open Topology
open MeasureTheory

/-- The risk-neutral owner's expected return: E[π - w(π)],
    where `μ` is the probability distribution over project profits π
    and `w` is the wage schedule as a function of realized profit.
    Risk neutrality is reflected in the linearity of the objective
    (no concave utility transformation is applied). -/
noncomputable def ownerExpectedReturn
    (μ : MeasureTheory.Measure ℝ)
    [MeasureTheory.IsProbabilityMeasure μ]
    (w : ℝ → ℝ) : ℝ :=
  ∫ π, (π - w π) ∂μ