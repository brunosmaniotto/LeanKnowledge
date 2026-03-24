import Mathlib
open Topology

/-- In sophisticated matching pennies (MWG Claim 7.7), the independence
    principle implies that one of β₂ or γ₂ must be zero.
    σ₂ is player 2's mixing probability. When player 1 plays Heads with certainty,
    Bayes' rule forces β₂ = 0 if σ₂ > 0 (β info set reached) and γ₂ = 0
    if σ₂ < 1 (γ info set reached). Since σ₂ ∈ [0,1], at least one holds. -/
theorem Claim_7_7_independence
    (σ₂ : ℝ) (hσ₂_nn : 0 ≤ σ₂) (hσ₂_le : σ₂ ≤ 1)
    (β₂ γ₂ : ℝ)
    (hβ₂ : 0 < σ₂ → β₂ = 0)
    (hγ₂ : σ₂ < 1 → γ₂ = 0)
    : β₂ = 0 ∨ γ₂ = 0 := by
  by_cases h : 0 < σ₂
  · exact Or.inl (hβ₂ h)
  · exact Or.inr (hγ₂ (by push_neg at h; linarith))