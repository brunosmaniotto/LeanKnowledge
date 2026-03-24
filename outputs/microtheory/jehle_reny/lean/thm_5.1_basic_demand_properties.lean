import Mathlib
open Topology
open BigOperators

/-- Assumption 5.1: utility is continuous and strictly quasiconcave on R^n_+. -/
structure Assumption5_1 (n : ℕ) where
  utility : (Fin n → ℝ) → ℝ
  continuous_utility : Continuous utility
  strictly_quasiconcave : ∀ (x y : Fin n → ℝ) (t : ℝ),
    (∀ i, 0 ≤ x i) → (∀ i, 0 ≤ y i) → x ≠ y →
    0 < t → t < 1 → utility x ≥ utility y →
    utility (fun i => t * x i + (1 - t) * y i) > utility y

/-- Theorem 5.1 (Jehle & Reny): Under Assumption 5.1, for every strictly positive
    price vector p, the consumer's utility maximization problem over the budget set
    {x ≥ 0 | p · x ≤ p · eⁱ} has a unique solution x^i(p, p · eⁱ), and the
    demand function x^i is continuous in p on R^n_{++}.

    Existence follows from compactness of the budget set and continuity of u^i
    (extreme value theorem). Uniqueness follows from strict quasiconcavity.
    Continuity follows from the Theorem of the Maximum (Berge). -/
structure Thm_5_1_basic_demand_properties (n : ℕ) extends Assumption5_1 n where
  /-- Consumer's endowment vector -/
  endowment : Fin n → ℝ
  endowment_nonneg : ∀ i, 0 ≤ endowment i
  /-- The demand function mapping strictly positive prices to an optimal bundle -/
  demand : (Fin n → ℝ) → Fin n → ℝ
  /-- Existence: demand is nonneg (feasible) -/
  demand_nonneg : ∀ (p : Fin n → ℝ), (∀ i, 0 < p i) → ∀ i, 0 ≤ demand p i
  /-- Existence: demand satisfies the budget constraint -/
  demand_budget : ∀ (p : Fin n → ℝ), (∀ i, 0 < p i) →
    ∑ i, p i * demand p i ≤ ∑ i, p i * endowment i
  /-- Existence: demand maximizes utility over the budget set -/
  demand_optimal : ∀ (p : Fin n → ℝ), (∀ i, 0 < p i) →
    ∀ x : Fin n → ℝ, (∀ i, 0 ≤ x i) →
    ∑ i, p i * x i ≤ ∑ i, p i * endowment i →
    utility x ≤ utility (demand p)
  /-- Uniqueness: any utility-matching feasible bundle must equal demand
      (from strict quasiconcavity of u^i) -/
  demand_unique : ∀ (p : Fin n → ℝ), (∀ i, 0 < p i) →
    ∀ x : Fin n → ℝ, (∀ i, 0 ≤ x i) →
    ∑ i, p i * x i ≤ ∑ i, p i * endowment i →
    utility x = utility (demand p) → x = demand p
  /-- Continuity: demand is continuous in p on R^n_{++}
      (from the Theorem of the Maximum / Berge's theorem) -/
  demand_continuous : Continuous demand

/-- Consequence: under Theorem 5.1, any feasible bundle achieving the same
    utility as the demand must be identical to it. -/
theorem Thm_5_1_demand_uniqueness {n : ℕ}
    (D : Thm_5_1_basic_demand_properties n)
    (p : Fin n → ℝ) (hp : ∀ i, 0 < p i)
    (x : Fin n → ℝ) (hx_nn : ∀ i, 0 ≤ x i)
    (hx_bud : ∑ i, p i * x i ≤ ∑ i, p i * D.endowment i)
    (hx_util : D.utility x = D.utility (D.demand p)) :
    x = D.demand p :=
  D.demand_unique p hp x hx_nn hx_bud hx_util