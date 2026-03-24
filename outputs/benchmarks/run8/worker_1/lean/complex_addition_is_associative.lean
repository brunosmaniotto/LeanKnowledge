import Mathlib

theorem complex_add_assoc (z₁ z₂ z₃ : ℂ) : z₁ + (z₂ + z₃) = (z₁ + z₂) + z₃ :=
  (add_assoc z₁ z₂ z₃).symm