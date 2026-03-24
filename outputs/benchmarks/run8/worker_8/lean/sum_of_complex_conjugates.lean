import Mathlib

theorem sum_of_complex_conjugates (z₁ z₂ : ℂ) : star (z₁ + z₂) = star z₁ + star z₂ :=
  star_add z₁ z₂