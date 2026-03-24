import Mathlib
open Topology

theorem budget_set_grows_and_steeper {p₁ p₂ p₂' w : ℝ}
    (hp₁ : 0 < p₁) (hp₂' : 0 < p₂') (hp₂ : 0 < p₂) (hp₂_lt : p₂' < p₂) :
    (∀ x₁ x₂ : ℝ, 0 ≤ x₂ → p₁ * x₁ + p₂ * x₂ ≤ w → p₁ * x₁ + p₂' * x₂ ≤ w) ∧
    (p₁ / p₂' > p₁ / p₂) := by
  constructor
  · intro x₁ x₂ hx₂ h
    nlinarith
  · show p₁ / p₂ < p₁ / p₂'
    apply div_lt_div_of_pos_left hp₁ hp₂' hp₂_lt