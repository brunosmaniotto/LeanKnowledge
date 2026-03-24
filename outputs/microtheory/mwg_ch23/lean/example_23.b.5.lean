import Mathlib

open Real
open Topology

/-- In a first-price sealed-bid auction with two buyers whose valuations are
independently drawn from Uniform[0,1], the strategy bᵢ(θᵢ) = θᵢ/2 constitutes
a Bayesian Nash equilibrium.

The key step: given opponent plays b₂(θ₂) = θ₂/2, buyer 1's expected payoff
from bidding b₁ when her valuation is θ₁ is (θ₁ - b₁) · (2 · b₁) = 2·θ₁·b₁ - 2·b₁².
This is maximized at b₁ = θ₁/2 (by completing the square or FOC). -/
theorem first_price_auction_BNE
    (θ₁ : ℝ) (hθ₁ : 0 ≤ θ₁ ∧ θ₁ ≤ 1) :
    ∀ b₁ : ℝ, (θ₁ - θ₁ / 2) * (2 * (θ₁ / 2)) ≥ (θ₁ - b₁) * (2 * b₁) := by
  intro b₁
  -- LHS = (θ₁/2) * θ₁ = θ₁²/2
  -- RHS = 2·θ₁·b₁ - 2·b₁²
  -- Difference = θ₁²/2 - 2·θ₁·b₁ + 2·b₁² = 2·(b₁ - θ₁/2)² ≥ 0
  nlinarith [sq_nonneg (b₁ - θ₁ / 2)]