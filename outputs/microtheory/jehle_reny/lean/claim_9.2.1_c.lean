import Mathlib

-- A bidder with value zero in a first-price auction has payoff v - b(v) = 0 - b(0) = -b(0).
-- Since the bid must be non-negative (b(0) ≥ 0) and the bidder would never accept negative
-- payoff (requiring -b(0) ≥ 0, i.e., b(0) ≤ 0), we conclude b(0) = 0.

theorem Claim_9_2_1_c (b_hat : ℝ → ℝ)
    (h_nonneg : 0 ≤ b_hat 0)
    (h_payoff : 0 - b_hat 0 ≥ 0) :
    b_hat 0 = 0 := by
  linarith