import Mathlib

lemma distance_formula_squared (x₁ y₁ x₂ y₂ : ℝ) : (x₁ - x₂)^2 + (y₁ - y₂)^2 = x₁^2 - 2*x₁*x₂ + x₂^2 + y₁^2 - 2*y₁*y₂ + y₂^2 := by
  ring