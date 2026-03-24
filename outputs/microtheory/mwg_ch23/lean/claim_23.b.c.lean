import Mathlib

open Real
open Topology

/-- In a pay-your-bid auction with 2 buyers and uniform valuations on [0,1],
    buyer 1's optimal bid is θ₁/2, not θ₁. This shows truth-telling is not optimal. -/
theorem auction_optimal_bid_not_truthful :
    ∀ θ₁ : ℝ, 0 < θ₁ → θ₁ ≤ 1 →
    -- The expected payoff function is f(x) = (θ₁ - x) * x
    -- Its maximum over [0,1] is at x = θ₁/2
    (∀ x : ℝ, (θ₁ - x) * x ≤ (θ₁ - θ₁ / 2) * (θ₁ / 2)) ∧
    -- And θ₁/2 ≠ θ₁, so truth-telling is not optimal
    θ₁ / 2 ≠ θ₁ := by
  intro θ₁ hpos hle
  constructor
  · intro x
    -- (θ₁ - x) * x = -(x - θ₁/2)² + θ₁²/4
    -- so maximum is θ₁²/4 at x = θ₁/2
    nlinarith [sq_nonneg (x - θ₁ / 2)]
  · linarith