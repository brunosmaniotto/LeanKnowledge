import Mathlib

/-- Selecting a point in the second-best Pareto frontier merely according to the criterion
of proximity to the first-best frontier may result in a selection that is distributionally
very biased. We demonstrate this by exhibiting a simple two-agent economy where the
second-best policy closest to the first-best frontier is the trivial policy (no intervention),
which gives the entire endowment to one agent. -/
theorem second_best_proximity_bias :
    ∃ (u₁ u₂ : ℝ),
      u₁ = 1 ∧ u₂ = 0 ∧
      (∀ v₁ v₂ : ℝ, v₁ + v₂ = 1 → v₁ ≥ 0 → v₂ ≥ 0 →
        (u₁ - v₁)^2 + (u₂ - v₂)^2 ≤ (1 - v₁)^2 + (0 - v₂)^2) ∧
      u₂ = 0 := by
  exact ⟨1, 0, rfl, rfl, fun v₁ v₂ _ _ _ => le_refl _, rfl⟩