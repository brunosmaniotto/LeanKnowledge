import Mathlib

open Matrix
open Topology

def IsNegSemidef' {N : ℕ} (M : Matrix (Fin N) (Fin N) ℝ) : Prop :=
  ∀ z : Fin N → ℝ, dotProduct z (M.mulVec z) ≤ 0

axiom slutskyMatrix (n : ℕ) (p : Fin n → ℝ) (y : ℝ) : Matrix (Fin n) (Fin n) ℝ

axiom slutsky_nsd (n : ℕ) (p : Fin n → ℝ) (y : ℝ) : IsNegSemidef' (slutskyMatrix n p y)