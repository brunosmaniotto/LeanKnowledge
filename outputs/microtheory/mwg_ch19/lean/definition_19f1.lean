import Mathlib

open Finset BigOperators
open BigOperators

/-- An asset allocation is constrained Pareto optimal if it is feasible
    (aggregate holdings ≤ 0 for each asset) and no alternative feasible
    allocation weakly improves every agent with at least one strict improvement. -/
structure ConstrainedParetoOptimal
    {I K : Type*} [Fintype I] [Fintype K]
    (z : I → K → ℝ)
    (U_star : I → (K → ℝ) → ℝ) : Prop where
  feasible : ∀ k : K, ∑ i : I, z i k ≤ 0
  no_improvement : ¬ ∃ z' : I → K → ℝ,
    (∀ k : K, ∑ i : I, z' i k ≤ 0) ∧
    (∀ i : I, U_star i (z' i) ≥ U_star i (z i)) ∧
    (∃ i : I, U_star i (z' i) > U_star i (z i))