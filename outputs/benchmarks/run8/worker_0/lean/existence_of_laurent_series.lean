import Mathlib

open Complex
open Set
open Filter

theorem existence_of_laurent_series (z₀ : ℂ) (R : ℝ) (hR : 0 < R) 
    (f : ℂ → ℂ) (hf : DifferentiableOn ℂ f (Metric.ball z₀ R \ {z₀})) :
    ∃ (a : ℤ → ℂ), ∀ z, z ∈ Metric.ball z₀ R \ {z₀} → 
      f z = ∑' (n : ℤ), a n * (z - z₀) ^ n := by
  sorry