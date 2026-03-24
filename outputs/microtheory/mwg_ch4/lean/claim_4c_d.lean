import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Aggregate compensated law of demand: if each consumer's individual compensated
    price change satisfies (p' - p) · [xᵢ(p', αᵢw') - xᵢ(p, αᵢw)] ≤ 0,
    then summing over all consumers gives the aggregate inequality ≤ 0. -/
theorem aggregate_compensated_law_of_demand
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (individual_effect : ι → ℝ)
    (h_individual : ∀ i, individual_effect i ≤ 0) :
    ∑ i, individual_effect i ≤ 0 := by
  apply Finset.sum_nonpos
  intro i _
  exact h_individual i