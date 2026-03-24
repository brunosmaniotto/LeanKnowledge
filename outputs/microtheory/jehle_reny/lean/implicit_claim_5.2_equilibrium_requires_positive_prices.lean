import Mathlib
open Topology Finset BigOperators Set

/-- Assumption 5.1: Consumer utility on ℝⁿ₊ is continuous, strongly increasing,
    and strictly quasiconcave. -/
structure Assn_5_1_ConsumerUtility {n : ℕ} (u : (Fin n → ℝ) → ℝ) where
  continuous : Continuous u
  strongly_increasing : ∀ x y, (∀ i, x i ≤ y i) → (∃ j, x j < y j) → u x < u y
  strictly_quasiconcave : ∀ (x y : Fin n → ℝ) (a : ℝ), x ≠ y → 0 < a → a < 1 → u ((1 - a) • x + a • y) > min (u x) (u y)

/-- Axiom: If consumers have strongly increasing utility functions and at least one good
    has a non-positive price, then aggregate excess demand cannot be zero. -/
axiom Claim_5e_u {n : ℕ} {I : Type} [Fintype I]
  (u_fns : I → (Fin n → ℝ) → ℝ)
  (h_consumer_utility : ∀ i, Assn_5_1_ConsumerUtility (u_fns i))
  (z_agg : (Fin n → ℝ) → (Fin n → ℝ))
  (p_vec : Fin n → ℝ)
  (h_non_pos_price : ∃ j, p_vec j ≤ 0) :
  z_agg p_vec ≠ 0

/-- Theorem (ImplicitClaim_5_2_equilibrium_requires_positive_prices):
    Under Assumption 5.1 (strongly increasing utility), aggregate excess demand can be zero
    only if all prices are positive. Hence Walrasian equilibrium requires p* ≫ 0. -/
theorem ImplicitClaim_5_2_equilibrium_requires_positive_prices {n : ℕ} {I : Type} [Fintype I]
  (u_fns : I → (Fin n → ℝ) → ℝ)
  (h_consumer_utility : ∀ i, Assn_5_1_ConsumerUtility (u_fns i))
  (z_agg : (Fin n → ℝ) → (Fin n → ℝ))
  (p_star : Fin n → ℝ)
  (h_excess_demand_zero : z_agg p_star = 0) :
  (∀ i, 0 < p_star i) :=
by
  -- Assume for contradiction that not all prices are strictly positive.
  by_contra h_not_all_positive
  -- This means there exists some index j such that p_star j ≤ 0.
  push_neg at h_not_all_positive
  obtain ⟨j, hj_non_pos⟩ := h_not_all_positive
  -- Use Claim_5e_u with the assumed conditions to derive a contradiction.
  have h_contradiction := Claim_5e_u u_fns h_consumer_utility z_agg p_star ⟨j, hj_non_pos⟩
  -- The axiom states that aggregate excess demand cannot be zero,
  -- but we assumed it is zero (h_excess_demand_zero).
  contradiction