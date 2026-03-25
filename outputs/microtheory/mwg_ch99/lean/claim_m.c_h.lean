import Mathlib

open Finset BigOperators

variable {N : ℕ}

def MWG.IsQuasiConcave (A : Set (Fin N → ℝ)) (f : (Fin N → ℝ) → ℝ) : Prop :=
  Convex ℝ A ∧
    ∀ t : ℝ, ∀ x ∈ A, ∀ x' ∈ A,
      f x ≥ t → f x' ≥ t →
        ∀ α : ℝ, 0 ≤ α → α ≤ 1 →
          f (α • x + (1 - α) • x') ≥ t