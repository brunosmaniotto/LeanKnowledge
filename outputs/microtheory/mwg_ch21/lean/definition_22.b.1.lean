import Mathlib

def UPS {I : ℕ} {α : Type*} (X : Set α) (u : Fin I → α → ℝ) : Set (Fin I → ℝ) :=
  {v | ∃ x ∈ X, ∀ i, v i ≤ u i x}