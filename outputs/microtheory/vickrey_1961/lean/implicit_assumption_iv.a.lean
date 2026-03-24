import Mathlib

open MeasureTheory
open ProbabilityTheory

/-- A two-item symmetric auction paradigm: two items are auctioned among `numBidders`
    similar bidders, where each bidder draws their valuation for an item from a
    common probability distribution `valueDist`. -/
structure TwoItemSymmetricAuction where
  /-- Number of bidders participating in the auction -/
  numBidders : ℕ
  /-- The auction has at least one bidder -/
  numBidders_pos : 0 < numBidders
  /-- Common probability distribution from which all bidders draw their valuations -/
  valueDist : ProbabilityMeasure ℝ