import Mathlib

open Set
open Topology

/-- Assumption 1.1: Minimal requirements on the consumption set X. -/
structure ConsumptionSetAxioms {n : ℕ} (X : Set (Fin n → ℝ)) : Prop where
  nonneg : X ⊆ {x | ∀ i, 0 ≤ x i}
  closed : IsClosed X
  convex : Convex ℝ X
  zero_mem : (0 : Fin n → ℝ) ∈ X