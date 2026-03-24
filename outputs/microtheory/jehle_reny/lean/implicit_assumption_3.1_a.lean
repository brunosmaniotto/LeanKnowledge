import Mathlib
open Topology

/-- A firm's decision problem: choosing a production plan to maximize
    profit, defined as the difference between revenue and cost. -/
structure FirmProfitMax where
  /-- The set of feasible production plans -/
  feasible : Set ℝ
  /-- Revenue as a function of the production plan -/
  revenue : ℝ → ℝ
  /-- Cost as a function of the production plan -/
  cost : ℝ → ℝ

/-- The firm's objective: profit = revenue − cost -/
noncomputable def FirmProfitMax.objective (P : FirmProfitMax) (y : ℝ) : ℝ :=
  P.revenue y - P.cost y

/-- A production plan maximizes profit if it is feasible and yields at least
    as much profit as every other feasible plan. -/
def FirmProfitMax.isOptimal (P : FirmProfitMax) (y : ℝ) : Prop :=
  y ∈ P.feasible ∧ ∀ y' ∈ P.feasible, P.objective y ≥ P.objective y'