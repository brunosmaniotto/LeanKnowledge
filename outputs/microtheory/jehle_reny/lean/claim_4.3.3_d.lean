import Mathlib

/-- Although Pareto efficiency requires that total surplus be maximised, a Pareto
    improvement need not result simply because total surplus has increased. Unless
    those who gain compensate those who lose, the change is not Pareto improving. -/
theorem claim_4_3_3_d :
    -- There exist allocations (u₁, u₂) and (v₁, v₂) such that total surplus
    -- increases (v₁ + v₂ > u₁ + u₂) but the change is not a Pareto improvement
    -- (some agent is strictly worse off).
    ∃ (u₁ u₂ v₁ v₂ : ℝ),
      v₁ + v₂ > u₁ + u₂ ∧  -- total surplus increases
      v₁ < u₁               -- but agent 1 is worse off, so not Pareto improving
    := by
  exact ⟨3, 1, 2, 4, by linarith, by linarith⟩