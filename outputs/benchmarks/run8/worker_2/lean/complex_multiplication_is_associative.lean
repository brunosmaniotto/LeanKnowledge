import Mathlib

theorem complex_mul_assoc (z₁ z₂ z₃ : ℂ) : z₁ * (z₂ * z₃) = (z₁ * z₂) * z₃ :=
  (mul_assoc z₁ z₂ z₃).symm