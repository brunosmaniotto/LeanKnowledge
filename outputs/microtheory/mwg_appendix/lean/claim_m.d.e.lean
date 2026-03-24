import Mathlib

theorem Claim_M_D_e (x₁ x₂ : ℝ) (h₁ : 0 < x₁) (h₂ : 0 < x₂) :
    2 * x₁ * x₂ > 0 := by
  positivity