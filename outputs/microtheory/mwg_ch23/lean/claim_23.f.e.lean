import Mathlib

variable {I : Type*} (J : I → ℝ) (y : I → ℝ)

/-- Optimal auction allocation: bidder i gets the good when their virtual valuation
    is the highest and positive. -/
theorem optimal_auction_allocation_rule
    (hy_optimal : ∀ i, (∀ j, j ≠ i → J i > J j) ∧ J i > 0 → y i = 1)
    (hy_zero : ∀ i, (∃ j, j ≠ i ∧ J j > J i) ∨ J i < 0 → y i = 0)
    (i : I)
    (h_wins : ∀ j, j ≠ i → J i > J j)
    (h_pos : J i > 0) :
    y i = 1 := by
  exact hy_optimal i ⟨h_wins, h_pos⟩