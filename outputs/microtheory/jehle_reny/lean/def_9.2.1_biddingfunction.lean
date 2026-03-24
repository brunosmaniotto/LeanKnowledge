import Mathlib

open scoped NNReal
open Topology

/-- A bidding function for a sealed-bid auction (Def 9.2.1).
    Maps each of bidder i's possible values v_i ∈ [0,1] to a non-negative bid b_i(v_i). -/
def BiddingFunction := Set.Icc (0 : ℝ) 1 → ℝ≥0