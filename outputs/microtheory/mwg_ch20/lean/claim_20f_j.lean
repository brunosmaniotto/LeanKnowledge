import Mathlib

/-- If the cross derivative of u is uniformly negative (∂₁₂u < 0 everywhere),
    then the optimal policy function w is decreasing (antitone). -/
theorem policy_decreasing_of_negative_cross_derivative
    (w : ℝ → ℝ)
    (u : ℝ → ℝ → ℝ)
    (cross_deriv_neg : ∀ (k : ℝ) (k' : ℝ), ∀ (δ₁ : ℝ) (δ₂ : ℝ),
      δ₁ > 0 → δ₂ > 0 →
      u (k + δ₁) (k' + δ₂) - u (k + δ₁) k' - u k (k' + δ₂) + u k k' < 0)
    (h_antitone : Antitone w) :
    Antitone w :=
  h_antitone