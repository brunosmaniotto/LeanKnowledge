import Mathlib
open Filter Topology Real BigOperators Finset
open Topology
open BigOperators

-- Define types for consumers and goods
variables {I L : Type*} [Fintype I] [Fintype L]
variables [DecidableEq I] [DecidableEq L]

-- Define consumer utility functions and endowments
-- u_i : (L → ℝ) → ℝ represents consumer i's utility function
-- e_i : L → ℝ represents consumer i's initial endowment (vector of n goods)
variables (u : I → (L → ℝ) → ℝ) (e : I → (L → ℝ))

-- Assumptions about utility functions: differentiable, strictly increasing, strictly concave
-- These are specified over the domain of consumption bundles, typically the non-negative orthant `(L → ℝ)`.
-- For simplicity, `Set.univ` is used as a placeholder for the domain where these properties hold.
variable (h_u_diff : ∀ i, Differentiable ℝ (u i))
variable (h_u_strictly_increasing : ∀ i, ∀ x y : L → ℝ, (∀ j, x j ≤ y j) → (x ≠ y) → (u i) x < (u i) y)
variable (h_u_strictly_concave : ∀ i, StrictConcaveOn ℝ (Set.univ : Set (L → ℝ)) (u i)) -- Using `StrictConcaveOn`

-- Assumption about aggregate endowment: e ≫ 0 (strictly positive in every component)
def aggregate_endowment_strictly_positive (e : I → (L → ℝ)) : Prop :=
  ∀ j : L, 0 < ∑ i : I, (e i) j

-- Definition of a Walrasian Equilibrium Allocation (WEA) `x_star` with price vector `p_star`.
-- This structure bundles the key conditions of a WEA for an exchange economy:
-- 1. Prices are non-negative and not all zero.
-- 2. Each consumer's allocation `x_star i` maximizes their utility `u i` given prices `p_star`
--    and their budget constraint (`p_star · x_i ≤ p_star · e_i`).
-- 3. Market clearing: aggregate demand equals aggregate endowment.
structure IsWalrasianEquilibriumAllocation (x_star : I → (L → ℝ)) (p_star : L → ℝ) : Prop where
  prices_non_neg : ∀ j, 0 ≤ p_star j
  prices_nonzero : p_star ≠ 0
  consumer_optimality : ∀ i,
    (∀ j, 0 ≤ (x_star i) j) ∧ -- x_star i is in the consumption set (non-negative orthant)
    (∀ x_prime : L → ℝ,
      (∀ j, 0 ≤ x_prime j) →
      (∑ j : L, p_star j * x_prime j) ≤ (∑ j : L, p_star j * (e i) j) →
      (u i) x_prime ≤ (u i) (x_star i)) -- x_star i maximizes utility under budget
  market_clearing : ∑ i : I, x_star i = ∑ i : I, (e i)

-- The core theorem statement for Exercise 6.11_a