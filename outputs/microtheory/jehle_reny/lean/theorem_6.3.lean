import Mathlib

open BigOperators

def SWF.Anonymous {I : ℕ} (W : (Fin I → ℝ) → ℝ) : Prop :=
  ∀ (σ : Equiv.Perm (Fin I)) (u : Fin I → ℝ), W (u ∘ σ) = W u