import Mathlib

open Topology BigOperators Filter Set Finset
open BigOperators

-- Proven Dependency: Assn_5_1_ConsumerUtility
/-- Assumption 5.1: Consumer utility on ℝⁿ₊ is continuous, strongly increasing,
    and strictly quasiconcave. -/
structure Assn_5_1_ConsumerUtility {n : ℕ} (u : (Fin n → ℝ) → ℝ) where
  continuous_on_R_n_plus : ContinuousOn u {x | ∀ i, 0 ≤ x i}
  strongly_increasing : ∀ {x y : Fin n → ℝ}, (∀ i, 0 ≤ x i) → (∀ i, 0 ≤ y i) →
    (∀ i, x i ≤ y i) → x ≠ y → u x < u y
  strictly_quasiconcave_on_R_n_plus : ∀ {x y : Fin n → ℝ},
    (∀ i, 0 ≤ x i) → (∀ i, 0 ≤ y i) → x ≠ y → ∀ (lambda_val : ℝ), 0 < lambda_val → lambda_val < 1 →
    u x ≤ u (lambda_val • x + (1 - lambda_val) • y) ∨ u y ≤ u (lambda_val • x + (1 - lambda_val) • y)

-- Proven Dependency: Def_5.2_consumer_problem (ConsumerBudgetSet)
def ConsumerBudgetSet {n : ℕ} (p e : Fin n → ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ k, 0 ≤ x k) ∧ ∑ k, p k * x k ≤ ∑ k, p k * e k}

-- The theorem asserts that there exists a scenario where the demand function
-- is not continuous due to the lack of a maximizer when a price is zero.