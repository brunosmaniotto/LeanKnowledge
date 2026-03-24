import Mathlib

open Finset BigOperators
open BigOperators

/-- Linear activity model: Y = {A α | α ≥ 0} for activity matrix A -/
structure LinearActivityModel (L N : ℕ) where
  A : Fin N → Fin L → ℝ

def LAM.prodSet {L N : ℕ} (m : LinearActivityModel L N) : Set (Fin L → ℝ) :=
  {y | ∃ α : Fin N → ℝ, (∀ j, α j ≥ 0) ∧ y = fun i => ∑ j, α j * m.A j i}