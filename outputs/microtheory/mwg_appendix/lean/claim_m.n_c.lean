import Mathlib

open scoped BigOperators

noncomputable section

variable {N : ℕ} (A : Set (Fin N → ℝ)) (u : (Fin N → ℝ) → (Fin N → ℝ) → ℝ) (δ : ℝ)

def SolvesDP (x : ℤ → (Fin N → ℝ)) : Prop :=
  ∀ t : ℤ, ∀ y ∈ A, u (x (t - 1)) (x t) + δ * u (x t) (x (t + 1)) ≥
    u (x (t - 1)) y + δ * u y (x (t + 1))