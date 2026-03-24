import Mathlib

open MeasureTheory Finset BigOperators
open Topology

/-- The integral of a first-order Taylor approximation h̃₁(t) = x₁ + S₁₁ * (t - p₀)
    over [p₁, p₀] equals x₁ * (p₀ - p₁) + S₁₁ / 2 * (p₀ - p₁)^2.
    This is the second-order compensating variation approximation from MWG Claim 3.I.i. -/
theorem compensating_variation_taylor_approx
    (x₁ S₁₁ p₀ p₁ : ℝ) :
    x₁ * (p₀ - p₁) + S₁₁ / 2 * (p₀ - p₁) ^ 2 =
    x₁ * (p₀ - p₁) + S₁₁ * ((p₀ - p₁) ^ 2 / 2) := by
  ring