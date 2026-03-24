import Mathlib

-- Part (i): When δ ≥ 1/2, deviation is unprofitable in repeated Bertrand duopoly:
-- the one-period deviation gain (1-δ)·π is at most the discounted punishment δ·π
theorem bertrand_cooperation (δ π : ℝ) (hδ : 1 / 2 ≤ δ) (hπ : 0 ≤ π) :
    (1 - δ) * π ≤ δ * π := by
  nlinarith [mul_nonneg hπ (show (0:ℝ) ≤ 2 * δ - 1 by linarith)]

-- Part (ii): When δ < 1/2, deviation is always strictly profitable for positive profits,
-- so no positive-profit outcome can be sustained in subgame perfect equilibrium