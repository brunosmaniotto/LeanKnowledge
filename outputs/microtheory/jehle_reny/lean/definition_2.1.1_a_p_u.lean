import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The closed half-space A(p, u) = {x ∈ ℝⁿ₊ | p · x ≥ E(p, u)},
    where E is an expenditure function. -/
noncomputable def HalfSpaceA {n : ℕ}
    (E : (Fin n → ℝ) → ℝ → ℝ)
    (p : Fin n → ℝ)
    (u : ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∑ i : Fin n, p i * x i ≥ E p u}