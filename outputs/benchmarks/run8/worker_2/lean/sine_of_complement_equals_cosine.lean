import Mathlib

open Real

theorem sin_complement_eq_cos (θ : ℝ) : sin (π / 2 - θ) = cos θ := by
  calc
    sin (π / 2 - θ) = sin (π / 2) * cos θ - cos (π / 2) * sin θ := by rw [sin_sub]
    _ = 1 * cos θ - 0 * sin θ := by rw [sin_pi_div_two, cos_pi_div_two]
    _ = cos θ := by ring