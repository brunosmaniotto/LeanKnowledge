import Mathlib

open Real

-- Part 1: For ℝ, |x₁ - x₂| = √((x₁ - x₂)²)
theorem euclidean_metric_R1 (x₁ x₂ : ℝ) :
    |x₁ - x₂| = Real.sqrt ((x₁ - x₂) * (x₁ - x₂)) := by
  rw [← Real.sqrt_sq_eq_abs (x₁ - x₂)]
  congr 1; ring

-- Part 2: For ℝ², dot product of difference equals sum of squared coordinate differences