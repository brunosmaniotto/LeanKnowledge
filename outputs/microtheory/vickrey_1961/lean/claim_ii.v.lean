import Mathlib

-- Define a simplified notion of a bidder for a single item auction.
inductive MyBidder
  | bidder1 : MyBidder
  | bidder2 : MyBidder
  deriving DecidableEq

-- A valuation function assigns a real value to each bidder for the single item.
def MyValuation := MyBidder → ℝ

-- An allocation specifies which bidder receives the single item.