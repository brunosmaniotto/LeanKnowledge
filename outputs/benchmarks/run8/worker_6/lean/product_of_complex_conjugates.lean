import Mathlib

theorem Product_of_Complex_Conjugates (z₁ z₂ : ℂ) : star (z₁ * z₂) = star z₁ * star z₂ :=
  star_mul' z₁ z₂