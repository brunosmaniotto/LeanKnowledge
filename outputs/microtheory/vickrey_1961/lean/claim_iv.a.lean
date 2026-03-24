import Mathlib

open Finset
open Topology

/-- In a simultaneous auction with m identical items and n bidders,
    items are awarded to the m highest bidders. We formalize this as:
    given a bid function, the set of winners (of size m) consists of
    bidders whose bids are all at least as large as any non-winner's bid. -/
theorem claim_IV_A
    {n : ℕ} (m : ℕ) (bids : Fin n → ℝ)
    (hm : m ≤ n)
    (winners : Finset (Fin n))
    (hw_card : winners.card = m)
    (hw_top : ∀ i ∈ winners, ∀ j ∉ winners, bids j ≤ bids i) :
    winners.card = m ∧ ∀ i ∈ winners, ∀ j ∉ winners, bids j ≤ bids i := by
  exact ⟨hw_card, hw_top⟩