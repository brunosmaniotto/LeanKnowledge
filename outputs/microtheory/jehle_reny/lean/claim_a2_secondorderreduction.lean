import Mathlib

/-- For the two-variable, one-constraint problem, the second derivative of the
    objective along the constraint (with x₂ as an implicit function of x₁) equals
    (1/g₂²) · [L₁₁·g₂² − 2·L₁₂·g₁·g₂ + L₂₂·g₁²], where Lᵢⱼ = fᵢⱼ − λ·gᵢⱼ.

    The LHS is d²y/dx₁² computed via chain rule with:
    • dx₂/dx₁ = −g₁/g₂ (implicit function theorem)
    • d²x₂/dx₁² = −(g₁₁ − 2g₁₂·g₁/g₂ + g₂₂·g₁²/g₂²) / g₂
    • f₂ = λ·g₂ (first-order condition) -/
theorem claim_A2_SecondOrderReduction
    (f₁₁ f₁₂ f₂₂ g₁ g₂ g₁₁ g₁₂ g₂₂ lam : ℝ)
    (hg₂ : g₂ ≠ 0) :
    f₁₁ + 2 * f₁₂ * (-g₁ / g₂) + f₂₂ * (-g₁ / g₂) ^ 2 +
      (lam * g₂) * (-(g₁₁ + 2 * g₁₂ * (-g₁ / g₂) + g₂₂ * (-g₁ / g₂) ^ 2) / g₂) =
    (1 / g₂ ^ 2) * ((f₁₁ - lam * g₁₁) * g₂ ^ 2 -
      2 * (f₁₂ - lam * g₁₂) * g₁ * g₂ +
      (f₂₂ - lam * g₂₂) * g₁ ^ 2) := by
  field_simp
  ring