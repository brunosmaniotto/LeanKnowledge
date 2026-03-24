import Mathlib

open Classical Finset
open Topology

/-- A first-price sealed-bid auction for a single indivisible good.
    Each bidder submits a sealed bid; the highest bidder wins and pays their own bid.
    Ties in bids are broken at random. -/
structure FirstPriceSealedBidAuction (ι : Type*) [Fintype ι] where
  /-- Each bidder's sealed bid. -/
  bids : ι → ℝ

namespace FirstPriceSealedBidAuction

variable {ι : Type*} [Fintype ι] [Nonempty ι]

/-- The maximum bid value. -/
noncomputable def maxBid (a : FirstPriceSealedBidAuction ι) : ℝ :=
  Finset.univ.sup' univ_nonempty a.bids

/-- The set of highest bidders (potential winners before tie-breaking). -/
noncomputable def winners (a : FirstPriceSealedBidAuction ι) : Finset ι :=
  Finset.univ.filter (fun i => a.bids i = a.maxBid)

/-- First-price payment rule: the winner pays their own bid; losers pay nothing. -/
noncomputable def payment (a : FirstPriceSealedBidAuction ι) (i : ι) : ℝ :=
  if a.bids i = a.maxBid then a.bids i else 0

end FirstPriceSealedBidAuction