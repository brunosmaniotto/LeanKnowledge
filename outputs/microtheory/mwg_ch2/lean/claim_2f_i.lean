import Mathlib

open Matrix Finset BigOperators
open Topology

variable {n : ℕ} [NeZero n]

def NegSemidef (M : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  ∀ v : Fin n → ℝ, dotProduct v (M.mulVec v) ≤ 0