import Mathlib

theorem Example_21D3 : ∀ x y : ℝ, x ≥ y ∨ y ≥ x := by
  intro x y
  exact le_total y x