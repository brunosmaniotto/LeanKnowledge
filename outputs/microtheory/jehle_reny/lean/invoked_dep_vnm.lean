import Mathlib

structure VNMUtility_Social where
  u : ℝ → ℝ

def IsPositiveAffineTransform (u₁ u₂ : ℝ → ℝ) : Prop :=
  ∃ (α β : ℝ), 0 < α ∧ ∀ x, u₂ x = α * u₁ x + β