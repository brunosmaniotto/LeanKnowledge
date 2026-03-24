import Mathlib

/--
`DutchAuctionExpectedGain value prob_win bid` represents the expected gain for a bidder
in a Dutch auction making a specific `bid`, given their `value` and their
subjective `prob_win` function. It formalizes the balancing act between
potential gain (`value - bid`) and probability of securing it (`prob_win bid`).
The function `prob_win` is assumed to return a probability between 0 and 1.
-/
def DutchAuctionExpectedGain (value : ℝ) (prob_win : ℝ → ℝ) (bid : ℝ) : ℝ :=
  (value - bid) * (prob_win bid)