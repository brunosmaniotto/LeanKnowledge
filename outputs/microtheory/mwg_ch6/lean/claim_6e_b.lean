import Mathlib

theorem mrs_certainty_line_uniform
    (π₁ π₂ u' : ℝ) (hu' : u' ≠ 0) :
    (π₁ * u') / (π₂ * u') = π₁ / π₂ := by
  rw [mul_div_mul_right _ _ hu']