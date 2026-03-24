import Mathlib

/-- Symmetric auctions are efficient: when all bidders use the same strictly
    increasing bidding function, the highest-value bidder submits the highest bid. -/
theorem symmetric_auction_efficient
    {ι : Type*} (v : ι → ℝ) (β : ℝ → ℝ) (hβ : StrictMono β)
    (bids : ι → ℝ) (h_sym : ∀ i, bids i = β (v i))
    {i j : ι} :
    bids i > bids j ↔ v i > v j := by
  simp only [h_sym]
  exact hβ.lt_iff_lt