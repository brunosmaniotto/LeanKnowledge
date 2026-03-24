import Mathlib

open Matrix

variable {N : ℕ}

def MWG.IsNegSemidef (M : Matrix (Fin N) (Fin N) ℝ) : Prop :=
  ∀ z : Fin N → ℝ, z ⬝ᵥ (M *ᵥ z) ≤ 0