import Mathlib

def LocallyNonsatiated (u : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, ∀ ε > 0, ∃ y : ℝ, |y - x| < ε ∧ u y > u x