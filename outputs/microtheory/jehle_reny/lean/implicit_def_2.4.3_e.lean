import Mathlib

def IsCARA (Rₐ : ℝ → ℝ) (S : Set ℝ) : Prop := ∀ w₁ ∈ S, ∀ w₂ ∈ S, Rₐ w₁ = Rₐ w₂