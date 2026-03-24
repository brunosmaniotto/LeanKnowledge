import Mathlib

open scoped BigOperators
open Finset

variable {L : ℕ}

def IsEfficientProd (Y : Set (Fin L → ℝ)) (y : Fin L → ℝ) : Prop :=
  y ∈ Y ∧ ¬∃ y' ∈ Y, y' ≠ y ∧ ∀ i, y i ≤ y' i