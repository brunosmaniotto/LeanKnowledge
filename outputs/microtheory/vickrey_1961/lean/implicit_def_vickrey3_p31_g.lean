import Mathlib

noncomputable def expected_gain (y₂ : ℝ → ℝ) (v₁ x : ℝ) : ℝ :=
  y₂ x * (v₁ - x)