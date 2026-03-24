import Mathlib

open Matrix

variable {N : Type*} [Fintype N] [DecidableEq N]

def Matrix.IsNegDefinite (M : Matrix N N ℝ) : Prop :=
  ∀ z : N → ℝ, z ≠ 0 → dotProduct z (M.mulVec z) < 0