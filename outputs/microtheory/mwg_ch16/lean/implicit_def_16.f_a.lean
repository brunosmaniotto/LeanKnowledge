import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- The Pareto optimality problem (16.F.1): maximize consumer 1's utility
    subject to utility floors for other consumers, market clearing, and
    production feasibility. -/
structure ParetoOptimalityProblem (L : ℕ) (I : ℕ) (J : ℕ)
    (hI : 2 ≤ I) (hJ : 1 ≤ J) where
  /-- Utility function for each consumer i -/
  u : Fin I → (Fin L → ℝ) → ℝ
  /-- Production transformation function for each firm j -/
  F : Fin J → (Fin L → ℝ) → ℝ
  /-- Aggregate endowment for each good ℓ -/
  ω : Fin L → ℝ
  /-- Utility floors for consumers i = 2,...,I -/
  ū : Fin I → ℝ
  /-- Consumption allocation: x ℓ i is consumer i's consumption of good ℓ -/
  x : Fin L → Fin I → ℝ
  /-- Production plan: y ℓ j is firm j's net output of good ℓ -/
  y : Fin L → Fin J → ℝ
  /-- Consumption is nonnegative -/
  consumption_nonneg : ∀ i : Fin I, ∀ ℓ : Fin L, 0 ≤ x ℓ i
  /-- Utility constraints: each consumer i ≠ 0 achieves at least ū_i -/
  utility_constraint : ∀ i : Fin I, i ≠ ⟨0, by omega⟩ → u i (fun ℓ => x ℓ i) ≥ ū i
  /-- Resource feasibility: total consumption ≤ endowment + total production -/
  resource_feasibility : ∀ ℓ : Fin L,
    ∑ i : Fin I, x ℓ i ≤ ω ℓ + ∑ j : Fin J, y ℓ j
  /-- Production feasibility: each firm's plan satisfies F_j(y_j) ≤ 0 -/
  production_feasibility : ∀ j : Fin J, F j (fun ℓ => y ℓ j) ≤ 0
  /-- This allocation maximizes consumer 1's utility among all feasible allocations -/
  optimality : ∀ (x' : Fin L → Fin I → ℝ) (y' : Fin L → Fin J → ℝ),
    (∀ i : Fin I, ∀ ℓ : Fin L, 0 ≤ x' ℓ i) →
    (∀ i : Fin I, i ≠ ⟨0, by omega⟩ → u i (fun ℓ => x' ℓ i) ≥ ū i) →
    (∀ ℓ : Fin L, ∑ i : Fin I, x' ℓ i ≤ ω ℓ + ∑ j : Fin J, y' ℓ j) →
    (∀ j : Fin J, F j (fun ℓ => y' ℓ j) ≤ 0) →
    u ⟨0, by omega⟩ (fun ℓ => x' ℓ ⟨0, by omega⟩) ≤
      u ⟨0, by omega⟩ (fun ℓ => x ℓ ⟨0, by omega⟩)