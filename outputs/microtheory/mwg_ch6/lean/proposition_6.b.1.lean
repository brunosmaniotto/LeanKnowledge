import Mathlib

open BigOperators Finset
open Topology

variable {N : ℕ}

def HasExpectedUtilityForm (U : (Fin N → ℝ) → ℝ) : Prop :=
  ∃ u : Fin N → ℝ, ∀ p : Fin N → ℝ, U p = ∑ n : Fin N, p n * u n