import Mathlib

open Matrix Finset BigOperators
open Topology

def NegSemidef {n : Type*} [Fintype n] [DecidableEq n] (M : Matrix n n ℝ) : Prop :=
  ∀ v : n → ℝ, dotProduct v (M.mulVec v) ≤ 0