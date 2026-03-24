import Mathlib

open Finset BigOperators
open BigOperators

-- We work in ℝ^L represented as Fin L → ℝ

variable {L : ℕ}

-- Budget set: {x ∈ ℝ^L_+ | p · x ≤ w}
def BudgetSet (p : Fin L → ℝ) (w : ℝ) : Set (Fin L → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∑ i, p i * x i ≤ w}

-- Walrasian demand: maximizers of u over the budget set