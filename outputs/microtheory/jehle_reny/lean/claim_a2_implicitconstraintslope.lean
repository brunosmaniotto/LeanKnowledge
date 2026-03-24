import Mathlib

theorem Claim_A2_ImplicitConstraintSlope
    (f₁ f₂ g₁ g₂ dx₂dx₁ : ℝ)
    (hg₂ : g₂ ≠ 0)
    (h_constraint : g₁ + g₂ * dx₂dx₁ = 0) :
    dx₂dx₁ = -g₁ / g₂ ∧
    f₁ + f₂ * dx₂dx₁ = f₁ - f₂ * (g₁ / g₂) := by
  have hdx : dx₂dx₁ = -g₁ / g₂ := by
    rw [eq_div_iff hg₂, mul_comm]
    linarith
  exact ⟨hdx, by rw [hdx]; ring⟩