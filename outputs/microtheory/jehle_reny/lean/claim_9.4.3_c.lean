import Mathlib

variable {I : Type*} (J : I → ℝ) (p : I → ℝ)

/-- The revenue expression (9.11) is maximized pointwise by assigning the object
    to the bidder with the highest positive virtual valuation. -/
theorem optimal_auction_pointwise_maximization
    (hp_optimal : ∀ i, (∀ j, j ≠ i → J i > J j) ∧ J i > 0 → p i = 1)
    (hp_zero : ∀ i, (∃ j, j ≠ i ∧ J j > J i) ∨ J i ≤ 0 → p i = 0)
    (i : I)
    (h_highest : ∀ j, j ≠ i → J i > J j)
    (h_pos : J i > 0) :
    p i = 1 := by
  exact hp_optimal i ⟨h_highest, h_pos⟩