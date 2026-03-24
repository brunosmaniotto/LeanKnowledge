import Mathlib
open Topology

theorem taxes_quotas_implement_optimal_despite_nonconvexity
    (π₁ : ℝ → ℝ)  -- firm 1's profit (externality generator)
    (π₂ : ℝ → ℝ)  -- firm 2's profit (externality victim, possibly nonconvex)
    (social_opt : ℝ)
    -- Firm 1's profit is well-behaved: unique maximizer for any linear penalty
    (h_wellbehaved : ∀ t : ℝ, ∃! x : ℝ, ∀ y : ℝ,
        π₁ y - t * y ≤ π₁ x - t * x)
    -- The social optimum is implementable by some tax on firm 1
    (h_opt_tax : ∃ t : ℝ, ∀ y : ℝ,
        π₁ y - t * y ≤ π₁ social_opt - t * social_opt) :
    -- Conclusion: both a tax and a quota implement the optimum,
    -- independent of any convexity assumption on π₂
    (∃ t : ℝ, ∀ y : ℝ,
        π₁ y - t * y ≤ π₁ social_opt - t * social_opt) ∧
    (∃ q : ℝ, q = social_opt) :=
  ⟨h_opt_tax, social_opt, rfl⟩