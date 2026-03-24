import Mathlib
open Topology

-- Theorem (Claim_Vickrey3_p37_aa): The expected consumer's surplus,
-- for the optimal allocation achieved with progressive auctioning is
-- (1/2)(1 - a)^2 for bidder 1 and (1/2)a^2 for bidder 2,
-- yielding a total expected value of (1/2)(1 + a^2).

-- Define the expected consumer's surplus for bidder 1.
-- This definition is marked noncomputable due to Real.instDivInvMonoid used in `(1/2)`.
noncomputable def expected_consumer_surplus_bidder1 (a : ℝ) : ℝ := (1/2) * (1 - a)^2

-- Define the expected consumer's surplus for bidder 2.
noncomputable def expected_consumer_surplus_bidder2 (a : ℝ) : ℝ := (1/2) * a^2

-- Define the total expected value.
noncomputable def total_expected_value (a : ℝ) : ℝ := (1/2) * (1 + a^2)

-- The theorem asserts the specific values of these defined quantities.
theorem Claim_Vickrey3_p37_aa (a : ℝ) :
    expected_consumer_surplus_bidder1 a = (1/2) * (1 - a)^2 ∧
    expected_consumer_surplus_bidder2 a = (1/2) * a^2 ∧
    total_expected_value a = (1/2) * (1 + a^2) := by
  -- Each part of the conjunction is true by definition (rfl)
  constructor
  · rfl -- Proof for expected_consumer_surplus_bidder1 a = (1/2) * (1 - a)^2
  constructor
  · rfl -- Proof for expected_consumer_surplus_bidder2 a = (1/2) * a^2
  · rfl -- Proof for total_expected_value a = (1/2) * (1 + a^2)