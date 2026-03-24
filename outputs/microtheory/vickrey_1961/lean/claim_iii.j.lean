import Mathlib

open scoped Classical

noncomputable def secondPricePayoff (valuation : ℝ) (own_bid : ℝ) (max_other_bid : ℝ) : ℝ :=
  if own_bid > max_other_bid then
    valuation - max_other_bid
  else
    0

theorem Claim_III_J_secondPrice_dominant_strategy (valuation : ℝ) (max_other_bid : ℝ) (bid : ℝ) :
    secondPricePayoff valuation valuation max_other_bid ≥ secondPricePayoff valuation bid max_other_bid := by
  dsimp only [secondPricePayoff]
  split_ifs with h_val_gt_m h_bid_gt_m
  -- Case 1: valuation > max_other_bid (h_val_gt_m) and bid > max_other_bid (h_bid_gt_m)
  -- Goal: valuation - max_other_bid ≥ valuation - max_other_bid
  rfl

  -- Case 2: valuation > max_other_bid (h_val_gt_m) and NOT (bid > max_other_bid)
  -- Goal: valuation - max_other_bid ≥ 0
  linarith [h_val_gt_m] -- `h_val_gt_m` is `valuation > max_other_bid`, so `valuation - max_other_bid > 0`

  -- Case 3: NOT (valuation > max_other_bid) and bid > max_other_bid (h_bid_gt_m)
  -- Goal: 0 ≥ valuation - max_other_bid
  linarith [h_val_gt_m] -- `h_val_gt_m` is `¬(valuation > max_other_bid)`, so `valuation ≤ max_other_bid`, implying `valuation - max_other_bid ≤ 0`

  -- Case 4: NOT (valuation > max_other_bid) and NOT (bid > max_other_bid)
  -- Goal: 0 ≥ 0
  rfl