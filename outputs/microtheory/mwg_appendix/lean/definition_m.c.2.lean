import Mathlib

open Matrix Finset

variable {N : ℕ}

def IsNegSemidef (M : Matrix (Fin N) (Fin N) ℝ) : Prop :=
  ∀ z : Fin N → ℝ, dotProduct z (M.mulVec z) ≤ 0