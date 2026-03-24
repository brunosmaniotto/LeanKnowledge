import Mathlib
open Topology

/-- A state of the world at date t=1. -/
abbrev State (S : ℕ) := Fin S

/-- An asset (security) is characterized by its return vector r = (r_1, ..., r_S) ∈ ℝ^S.
    Each component r_s represents the amount of good 1 received at date t=1 if state s occurs. -/
abbrev Asset (S : ℕ) := Fin S → ℝ

/-- The return of an asset in a given state s. -/
def Asset.returnInState {S : ℕ} (r : Asset S) (s : Fin S) : ℝ := r s