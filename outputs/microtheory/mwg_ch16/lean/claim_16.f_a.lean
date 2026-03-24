import Mathlib
open Topology

-- We model the equivalence between Pareto optimality and solutions to the
-- social planner's problem (Problem 16.F.1) abstractly.
-- The key insight: with strongly monotone preferences, maximizing one agent's
-- utility subject to others meeting utility floors characterizes exactly
-- the Pareto optimal allocations.

variable {Allocation : Type*} [Nonempty Allocation]
variable {I : ℕ} (hI : I ≥ 2)

-- Utility functions for I consumers
variable (u : Fin I → Allocation → ℝ)

-- Feasibility predicate
variable (Feasible : Allocation → Prop)

-- Pareto optimality: no feasible allocation makes everyone weakly better off
-- and someone strictly better off
def IsParetoOptimal (u : Fin I → Allocation → ℝ) (Feasible : Allocation → Prop)
    (x : Allocation) : Prop :=
  Feasible x ∧ ¬∃ y, Feasible y ∧ (∀ i, u i x ≤ u i y) ∧ (∃ i, u i x < u i y)

-- Solution to Problem 16.F.1: maximize u_0 subject to u_i ≥ ū_i for i ≥ 1
-- and feasibility