import Mathlib
open Topology

/-- A second-price sealed-bid auction (Vickrey auction).
  The award is made to the highest bidder, but at the price
  set by the second highest bid. -/
structure VickreyAuction (n : ℕ) (hn : 2 ≤ n) where
  /-- Bid submitted by each bidder -/
  bids : Fin n → ℝ
  /-- The index of the winning bidder -/
  winner : Fin n
  /-- The winner's bid is maximal among all bids -/
  winner_is_highest : ∀ i : Fin n, bids i ≤ bids winner
  /-- The price paid by the winner -/
  price : ℝ
  /-- The price equals the second-highest bid: the maximum bid among non-winners -/
  price_eq_second_highest :
    ∃ runner_up : Fin n, runner_up ≠ winner ∧
      price = bids runner_up ∧
      ∀ i : Fin n, i ≠ winner → bids i ≤ bids runner_up