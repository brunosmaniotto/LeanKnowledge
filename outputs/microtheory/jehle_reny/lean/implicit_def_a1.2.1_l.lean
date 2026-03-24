import Mathlib

open Set
open Topology

/-- The non-negative orthant ℝⁿ₊ = {x ∈ ℝⁿ | xᵢ ≥ 0 for all i}. -/
def nnOrthant (n : ℕ) : Set (Fin n → ℝ) :=
  {x | ∀ i, 0 ≤ x i}