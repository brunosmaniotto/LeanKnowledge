import Mathlib

def EqualWealthEffects (L I : ℕ) (demand : Fin I → Fin L → ℝ → ℝ) : Prop :=
  ∃ b : Fin L → ℝ, ∀ (i : Fin I) (ℓ : Fin L), ∃ c : ℝ, ∀ w : ℝ, demand i ℓ w = c + b ℓ * w