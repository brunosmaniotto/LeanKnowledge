import Mathlib

open Matrix

variable {N : ℕ}

def MWG.IsNegSemidef (M : Matrix (Fin N) (Fin N) ℝ) : Prop :=
  ∀ z : Fin N → ℝ, 0 ≤ z ⬝ᵥ (M *ᵥ z)