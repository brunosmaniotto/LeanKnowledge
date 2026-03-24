import Mathlib

open scoped BigOperators

variable {L : ℕ}

def coneProd (Y : Set (Fin L → ℝ)) : Set (Fin (L + 1) → ℝ) :=
  { y' | ∃ y ∈ Y, ∃ α : ℝ, 0 ≤ α ∧
    (∀ i : Fin L, y' (Fin.castSucc i) = α * y i) ∧
    y' (Fin.last L) = -α }