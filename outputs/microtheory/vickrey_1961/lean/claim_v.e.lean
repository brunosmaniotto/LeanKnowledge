import Mathlib

/-- Bidder utility in a second-price (Vickrey) auction:
    if your bid exceeds the opponent's, you win and pay the opponent's bid;
    otherwise you get 0. -/
noncomputable def utilityVickrey (v b opponent_bid : ℝ) : ℝ :=
  if b > opponent_bid then v - opponent_bid else 0

/-- Vickrey's core theorem (Claim V.E): truthful bidding (b = v) is a weakly
    dominant strategy when the price equals the first rejected bid.
    No matter what the opponent bids, deviating from one's true valuation
    never increases utility. -/
theorem vickrey_truthful_dominant (v b opponent_bid : ℝ) :
    utilityVickrey v v opponent_bid ≥ utilityVickrey v b opponent_bid := by
  simp only [utilityVickrey]
  split_ifs with h1 h2
  · -- both bids win: same payment, same utility
    linarith
  · -- truthful wins, deviation loses: v − opponent_bid ≥ 0 since v > opponent_bid
    linarith
  · -- truthful loses, deviation wins: 0 ≥ v − opponent_bid since v ≤ opponent_bid
    push_neg at h1
    linarith
  · -- both bids lose: 0 ≥ 0
    linarith