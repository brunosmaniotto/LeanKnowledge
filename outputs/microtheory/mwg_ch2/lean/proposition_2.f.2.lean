import Mathlib

open Matrix Finset BigOperators

variable {L : ℕ}

def IsNegSemidef (M : Matrix (Fin L) (Fin L) ℝ) : Prop :=
  ∀ v : Fin L → ℝ, v ⬝ᵥ M.mulVec v ≤ 0