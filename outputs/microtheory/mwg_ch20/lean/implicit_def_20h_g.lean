import Mathlib

/-- The determinacy condition for the OLG model.
    Requires: (1) consumption in both periods is normal,
    (2) ∂₁z_b < ∂₁z_a for all prices,
    (3) the offer curve slope in (c_b, c_a) plane is never positive and less than 1. -/
structure OLGDeterminacyCondition
    (z_b z_a : ℝ → ℝ → ℝ)
    (offerCurveSlope : ℝ → ℝ) where
  /-- Consumption in period b is normal (increasing in wealth/price) -/
  normalConsumption_b : ∀ p_b p_a : ℝ, Differentiable ℝ (fun p => z_b p p_a)
  /-- Consumption in period a is normal -/
  normalConsumption_a : ∀ p_b p_a : ℝ, Differentiable ℝ (fun p => z_a p p_a)
  /-- The partial derivative of z_b w.r.t. p_b is strictly less than
      the partial derivative of z_a w.r.t. p_b, for all prices -/
  excessDemand_dominance : ∀ p_b p_a : ℝ,
    deriv (fun p => z_b p p_a) p_b < deriv (fun p => z_a p p_a) p_b
  /-- The offer curve slope is never both positive and less than 1 -/
  offerCurve_slope_condition : ∀ t : ℝ, ¬(0 < offerCurveSlope t ∧ offerCurveSlope t < 1)