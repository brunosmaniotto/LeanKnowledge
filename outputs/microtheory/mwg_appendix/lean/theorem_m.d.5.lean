import Mathlib

open Matrix Finset BigOperators
open BigOperators

variable {N : ℕ} [NeZero N] [DecidableEq (Fin N)] [Fintype (Fin N)]

def MWG.HasDominantDiagonal (M : Matrix (Fin N) (Fin N) ℝ) : Prop :=
  ∀ i, ∑ j ∈ univ.filter (· ≠ i), |M i j| < |M i i|