import Mathlib

open BigOperators Finset

def budgetHyperplane (L : ℕ) (p : Fin L → ℝ) (w : ℝ) : Set (Fin L → ℝ) :=
  {x | ∑ i, p i * x i = w}