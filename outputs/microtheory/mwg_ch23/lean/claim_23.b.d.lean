import Mathlib

/-- In a second-price auction with 2 buyers, truth telling is weakly dominant. -/
theorem second_price_auction_truthful_dominant
    (v1 v2_hat : ℝ) :
    ∀ b : ℝ,
      (if v1 ≥ v2_hat then v1 - v2_hat else 0) ≥
      (if b ≥ v2_hat then v1 - v2_hat else 0) := by
  intro b
  by_cases h1 : v1 ≥ v2_hat <;> by_cases h2 : b ≥ v2_hat <;> simp only [ge_iff_le] <;>
    split_ifs <;> linarith