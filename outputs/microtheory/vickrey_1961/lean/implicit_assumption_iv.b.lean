import Mathlib
open Topology

/-- A sealed-bid second-price auction (Vickrey auction) for a single item.
Bidders submit sealed bids simultaneously; the highest bidder wins and
the price is determined by the second-highest bid.
Formalizes Implicit Assumption IV.B from Vickrey (1961). -/
structure SealedBidSecondPriceAuction (ι : Type*) [Fintype ι] where
  /-- The sealed bid submitted by each participant -/
  bid : ι → ℝ
  /-- The winning bidder -/
  winner : ι
  /-- The winner's bid is the highest -/
  winner_top : ∀ i, bid i ≤ bid winner
  /-- The transaction price -/
  price : ℝ
  /-- The price is an upper bound on all non-winner bids -/
  price_bound : ∀ i, i ≠ winner → bid i ≤ price
  /-- The price equals some non-winner's bid (i.e., it IS the second-highest bid) -/
  price_achieved : ∃ i, i ≠ winner ∧ bid i = price