import Mathlib

open Set
open Topology

/-- The standard consumption set X = ℝⁿ₊, the non-negative orthant.
    Each consumer's consumption bundle must have all non-negative components. -/
def standardConsumptionSet (n : ℕ) : Set (Fin n → ℝ) :=
  {x | ∀ i, 0 ≤ x i}