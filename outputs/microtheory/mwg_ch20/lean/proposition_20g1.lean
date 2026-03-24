import Mathlib
open Topology
open Finset

-- First Welfare Theorem: Walrasian equilibrium allocations are Pareto optimal
-- We model this abstractly with the key economic structure

structure OLGEconomy where
  I : ℕ                          -- number of consumers
  hI : 0 < I
  wealth : Fin I → ℝ             -- wealth of each consumer
  utility : Fin I → ℝ            -- utility at equilibrium allocation

/-- A Walrasian equilibrium satisfies: any Pareto-improving allocation
    costs strictly more than total wealth (from utility maximization),
    but feasibility requires cost ≤ total wealth (from profit maximization). -/
structure WalrasianEquilibrium (E : OLGEconomy) where
  -- For any alternative allocation with utilities alt_u:
  -- if it Pareto dominates (all ≥, some >), then its total cost exceeds total wealth
  pareto_improvement_exceeds_wealth :
    ∀ (alt_cost : Fin E.I → ℝ) (alt_u : Fin E.I → ℝ),
      (∀ i, alt_u i ≥ E.utility i) →
      (∃ i, alt_u i > E.utility i) →
      (∀ i, alt_cost i ≥ alt_u i → alt_cost i ≥ E.wealth i) →
      (∃ j, alt_cost j > E.wealth j) →
      Finset.sum Finset.univ alt_cost > Finset.sum Finset.univ E.wealth
  -- Any feasible allocation has total cost ≤ total wealth (profit maximization)
  feasible_within_wealth :
    ∀ (alt_cost : Fin E.I → ℝ),
      (∀ i, alt_cost i ≤ E.wealth i) →
      Finset.sum Finset.univ alt_cost ≤ Finset.sum Finset.univ E.wealth

def ParetoOptimal (E : OLGEconomy) : Prop :=
  ¬ ∃ (alt_u : Fin E.I → ℝ),
    (∀ i, alt_u i ≥ E.utility i) ∧
    (∃ i, alt_u i > E.utility i) ∧
    -- the alternative is feasible: each consumer's expenditure ≤ wealth
    (∃ (alt_cost : Fin E.I → ℝ), ∀ i, alt_cost i ≤ E.wealth i)