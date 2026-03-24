import Mathlib

theorem dutch_auction_bid_at_value_zero_gain (bidder_value bid_price : ℝ)
    (h_bid_at_value : bid_price = bidder_value) :
    (bidder_value - bid_price) = 0 := by
  rw [h_bid_at_value]
  simp