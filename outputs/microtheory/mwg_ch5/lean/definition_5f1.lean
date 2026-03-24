import Mathlib
open Topology

variable {n : ℕ}

def ProductionSet.IsEfficient (Y : Set (Fin n → ℝ)) (y : Fin n → ℝ) : Prop :=
  y ∈ Y ∧ ¬∃ y' ∈ Y, y' ≠ y ∧ ∀ i, y i ≤ y' i