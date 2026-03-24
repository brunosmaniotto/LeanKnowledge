import Mathlib

/-- Bid strategy in a Dutch auction with N players: player i bids ((N-1)/N) · vᵢ. -/
noncomputable def dutchAuctionBid (N : ℕ) (vi : ℝ) : ℝ :=
  ((↑N - 1) / ↑N) * vi

/-- Price in a Dutch auction with N players: if v is the highest value drawn,
    the price is pd = ((N-1)/N) · v. -/
noncomputable def dutchAuctionPrice (N : ℕ) (v : ℝ) : ℝ :=
  ((↑N - 1) / ↑N) * v