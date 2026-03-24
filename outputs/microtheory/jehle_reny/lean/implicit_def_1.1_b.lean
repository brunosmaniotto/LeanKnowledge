import Mathlib
open Topology

/-- The consumption set: the non-negative orthant ℝⁿ₊.
    A consumption bundle is a vector x = (x₁, …, xₙ) with each xᵢ ≥ 0,
    representing non-negative quantities of n infinitely divisible commodities. -/
def ConsumptionSet (n : ℕ) : Set (Fin n → ℝ) :=
  {x | ∀ i, 0 ≤ x i}