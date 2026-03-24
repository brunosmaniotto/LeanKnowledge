import Mathlib

open Finset BigOperators
open BigOperators

/-- A cost-allocation problem: given a finite set of projects indexed by `ι`,
    a coalitional cost function `C : Finset ι → ℝ`, and an allocation vector
    `c : ι → ℝ` such that the allocations sum exactly to the total cost `C(univ)`. -/
structure CostAllocationProblem (ι : Type*) [Fintype ι] [DecidableEq ι] where
  /-- Coalitional cost function (characteristic form) -/
  C : Finset ι → ℝ
  /-- Cost allocated to each project -/
  c : ι → ℝ
  /-- Budget balance: allocations sum to total cost -/
  budget_balance : ∑ i ∈ Finset.univ, c i = C Finset.univ