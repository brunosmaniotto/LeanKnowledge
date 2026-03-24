import Mathlib
open Topology

/-- The monopolist's pricing problem (MWG Problems 12.B.1 and 12.B.2).
    Bundles demand, cost, inverse demand, and the regularity assumptions. -/
structure MonopolistPricing where
  /-- Demand function x(p) -/
  demand : ℝ → ℝ
  /-- Cost function c(q) -/
  cost : ℝ → ℝ
  /-- Inverse demand function p(q) = x⁻¹(q) -/
  inverseDemand : ℝ → ℝ
  /-- p and c are continuous -/
  cost_continuous : Continuous cost
  inverseDemand_continuous : Continuous inverseDemand
  /-- p and c are twice differentiable for q > 0 -/
  cost_twice_diff : ∀ q : ℝ, 0 < q → DifferentiableAt ℝ cost q
  inverseDemand_twice_diff : ∀ q : ℝ, 0 < q → DifferentiableAt ℝ inverseDemand q
  /-- inverseDemand is the left inverse of demand -/
  inverse_spec : ∀ q : ℝ, demand (inverseDemand q) = q
  /-- p(0) > c'(0) : price at zero output exceeds marginal cost at zero -/
  price_exceeds_marginal_cost_at_zero :
    inverseDemand 0 > deriv cost 0
  /-- Unique optimal quantity q° ∈ (0, ∞) where p(q°) = c'(q°) -/
  optimalQty : ℝ
  optimalQty_pos : 0 < optimalQty
  optimalQty_eq : inverseDemand optimalQty = deriv cost optimalQty

/-- Price formulation objective: Max_p [p · x(p) − c(x(p))] (Problem 12.B.1) -/
noncomputable def MonopolistPricing.priceObjective (m : MonopolistPricing) (p : ℝ) : ℝ :=
  p * m.demand p - m.cost (m.demand p)

/-- Quantity formulation objective: Max_{q≥0} [p(q) · q − c(q)] (Problem 12.B.2) -/
noncomputable def MonopolistPricing.quantityObjective (m : MonopolistPricing) (q : ℝ) : ℝ :=
  m.inverseDemand q * q - m.cost q