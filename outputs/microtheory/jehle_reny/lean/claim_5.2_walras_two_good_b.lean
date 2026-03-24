import Mathlib

theorem claim_5_2_walras_two_good_b
    (p₁ p₂ z₁ z₂ : ℝ)
    (hp₁ : 0 < p₁) (hp₂ : 0 < p₂)
    (hwalras : p₁ * z₁ + p₂ * z₂ = 0)
    (hz₁ : 0 < z₁) :
    z₂ < 0 := by
  nlinarith [mul_pos hp₁ hz₁]