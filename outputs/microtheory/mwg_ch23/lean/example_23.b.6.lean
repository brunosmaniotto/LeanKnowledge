import Mathlib
open Topology

/-- Buyer's payoff from bidding b when value is v, opponent bids d -/
noncomputable def payoff (v b d : ℝ) : ℝ := if b > d then v - d else 0

/-- Truthful bidding (b_i = θ_i) is weakly dominant in a second-price auction:
    for any value v, opponent bid d, and alternative bid b,
    bidding v yields at least as high a payoff as bidding b. -/
theorem Example_23_B_6_second_price_truthful_dominant (v b d : ℝ) :
    payoff v v d ≥ payoff v b d := by
  unfold payoff
  split_ifs <;> linarith