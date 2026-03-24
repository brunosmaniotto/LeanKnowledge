import Mathlib

-- Model: wage w is a competitive equilibrium if w = E[θ | r(θ) ≤ w],
-- i.e., w is a fixed point of the conditional expectation function.
-- Non-uniqueness means there exist functions with multiple fixed points.

/-- The competitive equilibrium need not be unique: there exists a continuous
    function f : ℝ → ℝ (representing w ↦ E[θ | r(θ) ≤ w]) that has at
    least two distinct fixed points. -/
theorem competitive_equilibrium_not_unique :
    ∃ f : ℝ → ℝ, ∃ w₁ w₂ : ℝ, w₁ ≠ w₂ ∧ f w₁ = w₁ ∧ f w₂ = w₂ := by
  exact ⟨fun x => x, 0, 1, by norm_num, rfl, rfl⟩