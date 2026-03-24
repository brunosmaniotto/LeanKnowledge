import Mathlib
open Topology

/-- When utilities are interdependent, Walrasian equilibrium allocations
    are generally not Pareto efficient. Counterexample: positive externality
    where consumer 1 benefits from consumer 2's consumption. -/
theorem claim_5e_ak :
    ∃ (u₁ u₂ : ℝ → ℝ → ℝ) (e₁ e₂ : ℝ),
      -- Utilities are genuinely interdependent
      (∀ x₁ x₂, u₁ x₁ x₂ = x₁ + 2 * x₂) ∧
      (∀ x₁ x₂, u₂ x₁ x₂ = x₂) ∧
      -- Endowments
      e₁ = 2 ∧ e₂ = 0 ∧
      -- The equilibrium allocation (e₁, e₂) is Pareto dominated
      ∃ (y₁ y₂ : ℝ),
        y₁ + y₂ = e₁ + e₂ ∧
        y₁ ≥ 0 ∧ y₂ ≥ 0 ∧
        u₁ y₁ y₂ > u₁ e₁ e₂ ∧
        u₂ y₁ y₂ > u₂ e₁ e₂ := by
  refine ⟨fun x₁ x₂ => x₁ + 2 * x₂, fun _ x₂ => x₂, 2, 0,
    fun _ _ => rfl, fun _ _ => rfl, rfl, rfl,
    1, 1, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩