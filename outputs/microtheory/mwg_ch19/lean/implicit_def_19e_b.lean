import Mathlib
open Topology

/-- A portfolio is a vector of asset trades z = (z₁, ..., z_K) ∈ ℝ^K. -/
structure Portfolio (K : ℕ) where
  trades : Fin K → ℝ

/-- The return matrix R is an S × K matrix whose (s, k) entry rₛₖ
    gives the return of asset k in state s. -/
abbrev ReturnMatrix (S K : ℕ) := Matrix (Fin S) (Fin K) ℝ