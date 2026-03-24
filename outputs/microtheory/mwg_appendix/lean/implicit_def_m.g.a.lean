import Mathlib

open Set

def MWG.IsStrictlyConvex {N : ℕ} (A : Set (Fin N → ℝ)) : Prop :=
  ∀ x ∈ A, ∀ x' ∈ A, x ≠ x' → ∀ α : ℝ, 0 < α → α < 1 →
    α • x + (1 - α) • x' ∈ interior A