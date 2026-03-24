import Mathlib

theorem edgeworth_walras_law
    (p₁ p₂ : ℝ)
    (x₁₁ x₁₂ x₂₁ x₂₂ : ℝ)
    (e₁₁ e₁₂ e₂₁ e₂₂ : ℝ)
    (hp₂ : p₂ ≠ 0)
    (hbudget1 : p₁ * x₁₁ + p₂ * x₁₂ = p₁ * e₁₁ + p₂ * e₁₂)
    (hbudget2 : p₁ * x₂₁ + p₂ * x₂₂ = p₁ * e₂₁ + p₂ * e₂₂)
    (hclear1 : x₁₁ + x₂₁ = e₁₁ + e₂₁) :
    x₁₂ + x₂₂ = e₁₂ + e₂₂ := by
  have hadd : p₁ * x₁₁ + p₂ * x₁₂ + (p₁ * x₂₁ + p₂ * x₂₂) =
              p₁ * e₁₁ + p₂ * e₁₂ + (p₁ * e₂₁ + p₂ * e₂₂) := by linarith
  have hclear1' : p₁ * (x₁₁ + x₂₁) = p₁ * (e₁₁ + e₂₁) := by
    rw [hclear1]
  have hkey : p₂ * (x₁₂ + x₂₂) = p₂ * (e₁₂ + e₂₂) := by nlinarith
  exact mul_left_cancel₀ hp₂ hkey