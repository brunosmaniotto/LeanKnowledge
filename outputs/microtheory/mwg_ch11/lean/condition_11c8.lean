import Mathlib

open scoped BigOperators
open Finset

-- Let φ_i' be marginal_benefit_i and c' be marginal_cost.
-- These are functions from ℝ to ℝ, indexed by i for marginal_benefit_i.
-- I is the number of individuals.
-- q_star_star is the specific public good level.
-- p is a function that maps individual index to their personalized price.
variable {I : ℕ} {q_star_star : ℝ} {p : ℕ → ℝ}
variable {marginal_benefit_i : ℕ → ℝ → ℝ} {marginal_cost : ℝ → ℝ}

-- Condition 11.C.6: Individual FOC for public good.
-- For each individual i, their marginal benefit from the public good q_star_star is
-- less than or equal to their personalized price p_i.
-- If q_star_star > 0, then the marginal benefit equals the personalized price.
def condition_11C6_def (i : ℕ) : Prop :=
  marginal_benefit_i i q_star_star ≤ p i ∧ (q_star_star > 0 → marginal_benefit_i i q_star_star = p i)

-- Condition 11.C.7: Public good supply condition.
-- The sum of personalized prices equals the marginal cost of the public good.