import Mathlib

open Real
open Topology

/-- A market where individual marginal-cost curves of sellers have moderate positive slopes
and individual marginal-value curves of buyers have moderate negative slopes. -/
structure ModerateSlopes
    (nSellers nBuyers : ℕ)
    (sellerCost : Fin nSellers → ℝ → ℝ)
    (buyerValue : Fin nBuyers → ℝ → ℝ) where
  /-- Each seller's marginal-cost function is differentiable. -/
  seller_diff : ∀ i, Differentiable ℝ (sellerCost i)
  /-- Each buyer's marginal-value function is differentiable. -/
  buyer_diff : ∀ i, Differentiable ℝ (buyerValue i)
  /-- Positive slope lower bound for sellers' marginal cost. -/
  slopeLB : ℝ
  /-- Positive slope upper bound for sellers' marginal cost. -/
  slopeUB : ℝ
  /-- Negative slope lower bound (in magnitude) for buyers' marginal value. -/
  valSlopeLB : ℝ
  /-- Negative slope upper bound (in magnitude) for buyers' marginal value. -/
  valSlopeUB : ℝ
  slopeLB_pos : 0 < slopeLB
  slopeUB_pos : 0 < slopeUB
  lb_le_ub : slopeLB ≤ slopeUB
  valSlopeLB_pos : 0 < valSlopeLB
  valSlopeUB_pos : 0 < valSlopeUB
  valLB_le_ub : valSlopeLB ≤ valSlopeUB
  /-- Each seller's marginal-cost derivative is bounded between slopeLB and slopeUB (moderate positive slope). -/
  seller_slope : ∀ i x, slopeLB ≤ deriv (sellerCost i) x ∧ deriv (sellerCost i) x ≤ slopeUB
  /-- Each buyer's marginal-value derivative is bounded between -valSlopeUB and -valSlopeLB (moderate negative slope). -/
  buyer_slope : ∀ i x, -valSlopeUB ≤ deriv (buyerValue i) x ∧ deriv (buyerValue i) x ≤ -valSlopeLB