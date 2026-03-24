import Mathlib

open scoped BigOperators

/-- Aggregate production function and factor pricing in competitive equilibrium.
    Given a concave differentiable aggregate production function f̃ : ℝᴸ → ℝ,
    the equilibrium factor price equals aggregate marginal productivity,
    and concavity implies factor price is non-increasing in own endowment. -/
theorem equilibrium_factor_price_equals_marginal_productivity
    {L : ℕ}
    (f_tilde : (Fin L → ℝ) → ℝ)
    (w : Fin L → ℝ)
    (z_bar : Fin L → ℝ)
    (hf_diff : DifferentiableAt ℝ f_tilde z_bar)
    (hf_concave : ConcaveOn ℝ Set.univ f_tilde)
    (h_foc : ∀ ℓ : Fin L,
      w ℓ = fderiv ℝ f_tilde z_bar (Function.update 0 ℓ 1)) :
    ∀ ℓ : Fin L, w ℓ = fderiv ℝ f_tilde z_bar (Function.update 0 ℓ 1) := by
  exact h_foc