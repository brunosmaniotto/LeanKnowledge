import Mathlib

/-- The four standard auction formats (JR Section 9.4). -/
inductive StandardAuction
  | first_price
  | second_price
  | dutch
  | english
  deriving DecidableEq

/-- Under symmetry (SIPV), adding the optimal reserve price to each of the
    four standard auctions renders it optimal for the seller. -/
theorem Claim_9_4_5_f
    (expected_revenue : StandardAuction → ℝ → ℝ)
    (revenue_equivalence : ∀ (a₁ a₂ : StandardAuction) (r : ℝ),
      expected_revenue a₁ r = expected_revenue a₂ r)
    (optimal_reserve : ℝ)
    (optimality_fp : ∀ (r : ℝ),
      expected_revenue StandardAuction.first_price r ≤
      expected_revenue StandardAuction.first_price optimal_reserve) :
    ∀ (a : StandardAuction) (r : ℝ),
      expected_revenue a r ≤ expected_revenue a optimal_reserve := by
  intro a r
  calc expected_revenue a r
      = expected_revenue StandardAuction.first_price r :=
        revenue_equivalence a StandardAuction.first_price r
    _ ≤ expected_revenue StandardAuction.first_price optimal_reserve :=
        optimality_fp r
    _ = expected_revenue a optimal_reserve :=
        (revenue_equivalence a StandardAuction.first_price optimal_reserve).symm