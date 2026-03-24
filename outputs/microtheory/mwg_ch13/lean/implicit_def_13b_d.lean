import Mathlib
open Topology
open BigOperators

/-- Convention for equilibrium when no workers accept employment (Θ* = ∅).
    When the set of accepting workers is empty, each firm's expectation of
    potential employees' average productivity is the unconditional expectation E[θ],
    and the equilibrium wage equals this unconditional expectation. -/
structure EmptyPoolEquilibriumConvention (θ : Type*) [Fintype θ] where
  /-- Productivity of each worker type -/
  productivity : θ → ℝ
  /-- Distribution weight (probability) for each type -/
  weight : θ → ℝ
  /-- Weights are nonneg -/
  weight_nonneg : ∀ t, 0 ≤ weight t
  /-- Weights sum to 1 -/
  weight_sum : ∑ t, weight t = 1
  /-- The set of workers accepting employment in equilibrium -/
  acceptingWorkers : Finset θ
  /-- The acceptance set is empty -/
  empty_pool : acceptingWorkers = ∅
  /-- The equilibrium wage -/
  w_star : ℝ
  /-- The unconditional expectation E[θ] -/
  unconditional_expectation : ℝ := ∑ t, weight t * productivity t
  /-- Firms' belief equals the unconditional expectation when pool is empty -/
  firm_belief_eq : w_star = unconditional_expectation