import Mathlib
open Topology

/-- An ordinary or progressive auction (English auction): a procedure in which
    bids are freely made and publicly announced until no purchaser wishes to
    make any further higher bid. -/
structure ProgressiveAuction (n : ℕ) where
  /-- Private valuation of each bidder for the item -/
  valuation : Fin n → ℝ
  /-- The publicly announced highest bid at each round -/
  highBid : ℕ → ℝ
  /-- The leading bidder at each round -/
  leader : ℕ → Fin n
  /-- The auction is progressive: announced bids are non-decreasing -/
  bids_nondecreasing : ∀ t, highBid t ≤ highBid (t + 1)
  /-- Termination: the auction ends when no bidder wishes to bid higher -/
  terminates : ∃ T, ∀ t, T ≤ t → highBid t = highBid T