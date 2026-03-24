import Mathlib
open Topology

noncomputable section

/-- A second-price sealed-bid auction with reserve price ρ*.
    Under symmetry, this implements the optimal direct selling mechanism.
    The highest bidder above ρ* wins and pays max(second-highest bid, ρ*).
    If no bids exceed ρ*, the seller keeps the object. -/
structure SecondPriceReserveAuction (n : ℕ) (hn : 2 ≤ n) where
  /-- Bids submitted by each bidder -/
  bids : Fin n → ℝ
  /-- The reserve price ρ* -/
  reserve : ℝ
  /-- The winner, if any: highest bidder with bid strictly above reserve -/
  winner : Option (Fin n)
  /-- A winner's bid exceeds the reserve price -/
  winner_above_reserve : ∀ w, winner = some w → bids w > reserve
  /-- The winner has the highest bid -/
  winner_is_highest : ∀ w, winner = some w → ∀ i : Fin n, bids i ≤ bids w
  /-- No winner iff all bids are at or below the reserve -/
  no_winner_iff : winner = none ↔ ∀ i : Fin n, bids i ≤ reserve
  /-- The price paid by the winner -/
  price : ℝ
  /-- Price equals max(second-highest bid, reserve) -/
  price_eq_max_second_reserve : ∀ w, winner = some w →
    ∃ runner_up : Fin n, runner_up ≠ w ∧
      price = max (bids runner_up) reserve ∧
      ∀ i : Fin n, i ≠ w → bids i ≤ bids runner_up

/-- Truth-telling is a weakly dominant strategy in a second-price auction
    with reserve price: bidding one's true value v yields utility at least
    as high as any alternative bid b, regardless of the effective price
    (= max of competing bids and reserve). -/
theorem second_price_reserve_truth_telling_dominant
    (v effective_price b : ℝ) :
    (if v > effective_price then v - effective_price else (0 : ℝ)) ≥
    (if b > effective_price then v - effective_price else (0 : ℝ)) := by
  split_ifs <;> linarith