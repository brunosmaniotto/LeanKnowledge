import Mathlib

open Set Finset BigOperators
open BigOperators

variable {L : ℕ} {J : ℕ}

structure Assumption52 (Y : Set (Fin L → ℝ)) : Prop where
  closed : IsClosed Y
  convex : Convex ℝ Y
  zero_mem : (0 : Fin L → ℝ) ∈ Y
  free_disposal : ∀ y ∈ Y, ∀ y' : Fin L → ℝ, (∀ i, y' i ≤ y i) → y' ∈ Y

def aggregateProductionSet (Ys : Fin J → Set (Fin L → ℝ)) : Set (Fin L → ℝ) :=
  {y | ∃ ys : Fin J → Fin L → ℝ, (∀ j, ys j ∈ Ys j) ∧ y = ∑ j, ys j}