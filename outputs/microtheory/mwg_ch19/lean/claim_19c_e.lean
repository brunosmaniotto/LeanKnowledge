import Mathlib

theorem mrs_equals_probability_ratio
    (π₁ π₂ : ℝ) (hπ₂ : π₂ > 0)
    (u' : ℝ → ℝ) (x : ℝ) (hu' : u' x > 0) :
    (π₁ * u' x) / (π₂ * u' x) = π₁ / π₂ := by
  field_simp