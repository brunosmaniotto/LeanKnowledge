import Mathlib

open Finset BigOperators
open BigOperators

/-- The Walrasian (competitive) budget set: all consumption bundles x ∈ ℝ^L₊
    such that p · x ≤ w, where p is a price vector and w is wealth. -/
def walrasianBudgetSet (L : ℕ) (p : Fin L → ℝ) (w : ℝ) : Set (Fin L → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∑ i : Fin L, p i * x i ≤ w}