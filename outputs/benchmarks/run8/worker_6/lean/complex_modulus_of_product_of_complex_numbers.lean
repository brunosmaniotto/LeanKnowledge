import Mathlib

theorem complex_modulus_product (z₁ z₂ : ℂ) : ‖z₁ * z₂‖ = ‖z₁‖ * ‖z₂‖ :=
  Complex.norm_mul z₁ z₂