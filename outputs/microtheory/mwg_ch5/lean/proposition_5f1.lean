import Mathlib
open BigOperators Finset
open Topology

variable {n : ℕ}

def IsEfficient (Y : Set (Fin n → ℝ)) (y : Fin n → ℝ) : Prop :=
  y ∈ Y ∧ ¬∃ y' ∈ Y, y' ≠ y ∧ ∀ i, y i ≤ y' i