import Mathlib

open Complex

theorem complex_mul_distrib (z₁ z₂ z₃ : ℂ) :
    z₁ * (z₂ + z₃) = z₁ * z₂ + z₁ * z₃ ∧ (z₂ + z₃) * z₁ = z₂ * z₁ + z₃ * z₁ := by
  constructor
  · apply Complex.ext
    · simp [add_re, mul_re]
      ring
    · simp [add_im, mul_im]
      ring
  · apply Complex.ext
    · simp [add_re, mul_re]
      ring
    · simp [add_im, mul_im]
      ring