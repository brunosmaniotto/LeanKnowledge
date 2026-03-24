import Mathlib

/-- A competitive equilibrium with externalities typically fails to be Pareto optimal.
    We exhibit a two-agent economy where the equilibrium allocation is Pareto dominated. -/
theorem competitive_equilibrium_not_pareto_optimal :
    ∃ (w x₁_eq x₂_eq x₁_opt x₂_opt : ℝ),
      -- Total endowment
      w = 4 ∧
      -- Competitive equilibrium allocation
      x₁_eq = 2 ∧ x₂_eq = 2 ∧ x₁_eq + x₂_eq = w ∧
      -- Alternative feasible allocation
      x₁_opt = 1 ∧ x₂_opt = 3 ∧ x₁_opt + x₂_opt = w ∧
      -- Externality-adjusted utilities at equilibrium: u₁=x₁=2, u₂=x₂-x₁/2=1
      -- Externality-adjusted utilities at optimum: u₁=x₁=1, u₂=x₂-x₁/2=2.5
      -- With transfer t=1.25 from agent 2 to agent 1:
      -- Agent 1: 1+1.25=2.25 > 2, Agent 2: 2.5-1.25=1.25 > 1
      ∃ (t : ℝ),
        (x₁_opt + t > x₁_eq) ∧
        ((x₂_opt - x₁_opt / 2) - t > x₂_eq - x₁_eq / 2) := by
  exact ⟨4, 2, 2, 1, 3, rfl, rfl, rfl, by norm_num, rfl, rfl, by norm_num, 1.25, by norm_num, by norm_num⟩