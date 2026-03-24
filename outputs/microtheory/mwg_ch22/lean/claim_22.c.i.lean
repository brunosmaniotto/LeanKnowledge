import Mathlib

-- A utility possibility set over a finite index type I
-- Pareto optimality: no other point in U weakly dominates u with strict improvement somewhere
-- Maximin optimum: maximizes the minimum coordinate

variable {I : Type*} [Fintype I] [Nonempty I]

def IsPareto (U : Set (I → ℝ)) (u : I → ℝ) : Prop :=
  u ∈ U ∧ ¬∃ u' ∈ U, (∀ i, u i ≤ u' i) ∧ (∃ i, u i < u' i)