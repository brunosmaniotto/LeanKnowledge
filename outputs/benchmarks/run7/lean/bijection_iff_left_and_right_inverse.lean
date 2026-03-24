import Mathlib

open Function

variable {S T : Type*}

theorem left_inverse_eq_right_inverse (f : S → T) (g₁ g₂ : T → S) (h₁ : g₁ ∘ f = id) (h₂ : f ∘ g₂ = id) : g₁ = g₂ := by
  have h1 : LeftInverse g₁ f := by intro x; exact congr_fun h₁ x
  have h2 : RightInverse g₂ f := by intro x; exact congr_fun h₂ x
  exact h1.eq_rightInverse h2