import Mathlib

/--
A weighted social welfare function can increase even when some agents are worse off.
This formalizes the key insight: Pareto optimality does not preclude welfare improvements
under a social welfare function with heterogeneous weights.
-/
theorem welfare_improvement_without_pareto :
    ∃ (u₁ u₂ Λ₁ Λ₂ : ℝ),
      0 < Λ₁ ∧ 0 < Λ₂ ∧
      u₁ < 0 ∧
      0 < Λ₁ * u₁ + Λ₂ * u₂ := by
  exact ⟨-1, 3, 1, 1, by norm_num, by norm_num, by norm_num, by norm_num⟩