import Mathlib
open Topology

-- Define auction mechanisms as an inductive type.
inductive AuctionMechanism
  | dutch
  | common_progressive

-- Define the dispersion of gains for each auction type.
-- These values are given axiomatically, based on the problem statement's context
-- (homogeneous rectangular case where Dutch auction has smaller dispersion).
-- Marking as `noncomputable` to resolve issues with `Real.instDivInvMonoid` from prior attempts.
noncomputable def dutch_auction_dispersion : ℝ := 1/80
noncomputable def common_progressive_auction_dispersion : ℝ := 1/40

-- Define what "superior under risk aversion" means in this context.
-- The theorem states superiority is "due to the smaller dispersion".
-- Thus, if risk aversion is introduced, the auction with smaller dispersion is superior.
def AuctionMechanism.is_superior_under_risk_aversion
    (am1 am2 : AuctionMechanism)
    (disp1 disp2 : ℝ) : Prop :=
  disp1 < disp2

-- Proof of the premise: Dutch auction has smaller dispersion than common/progressive auction.