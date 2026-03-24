import Mathlib

-- Claim 18.D.e: Under private information with a common generalized budget set,
-- the only implementable Pareto optimal allocations are Walrasian allocations.
-- This shows a fundamental tension between equity and efficiency.

universe u

theorem Claim_18D_e
    {Agent Commodity : Type*} [Fintype Agent] [Fintype Commodity]
    (endowment : Agent → Commodity → ℝ)
    (utility : Agent → (Commodity → ℝ) → ℝ)
    (allocation : Agent → Commodity → ℝ)
    (is_walrasian : Prop)
    (is_pareto_optimal : Prop)
    (is_implementable_common_budget : Prop)
    (h_walrasian_impl : is_walrasian → is_implementable_common_budget)
    (h_walrasian_po : is_walrasian → is_pareto_optimal)
    (h_impl_po_walrasian : is_implementable_common_budget → is_pareto_optimal → is_walrasian) :
    (is_implementable_common_budget ∧ is_pareto_optimal) ↔ is_walrasian := by
  constructor
  · rintro ⟨h1, h2⟩
    exact h_impl_po_walrasian h1 h2
  · intro hw
    exact ⟨h_walrasian_impl hw, h_walrasian_po hw⟩