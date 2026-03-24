import Mathlib

open Matrix Finset BigOperators

variable {L : ℕ} [NeZero L]

def GrossSubstitutePattern (M : Matrix (Fin L) (Fin L) ℝ) : Prop :=
  (∀ i j, i ≠ j → M i j > 0) ∧ (∀ i, M i i < 0)