import Mathlib

/--
With state-dependent utility and actuarially fair insurance under equal
probabilities, a risk-averse decision maker will not fully insure:
the MRS at the certainty line (u₁'(w)/u₂'(w)) ≠ 1 when marginal
utilities differ across states.
-/
theorem state_dependent_utility_incomplete_insurance
    (u₁ u₂ : ℝ → ℝ)
    (hu₁ : Differentiable ℝ u₁)
    (hu₂ : Differentiable ℝ u₂)
    (w : ℝ)
    (h_state_dep : deriv u₁ w ≠ deriv u₂ w)
    (hu₂_pos : 0 < deriv u₂ w)
    : deriv u₁ w / deriv u₂ w ≠ 1 := by
  intro h_eq
  have h2 : deriv u₁ w = deriv u₂ w := by
    field_simp at h_eq
    linarith
  exact h_state_dep h2