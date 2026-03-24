import Mathlib

/-- In a competitive market with per-unit tax t > 0, the consumer surplus loss
    exceeds tax revenue by the deadweight loss triangle. -/
theorem exercise_4_26_c
    (t : ℝ) (ht : t > 0)
    (q₀ q₁ : ℝ) (hq : q₀ > q₁)
    -- CS loss = tax revenue rectangle + deadweight loss triangle
    (CS_loss : ℝ) (hCS : CS_loss = t * q₁ + 1 / 2 * t * (q₀ - q₁))
    -- Tax revenue = tax rate × post-tax equilibrium quantity
    (tax_revenue : ℝ) (hT : tax_revenue = t * q₁)
    : CS_loss > tax_revenue := by
  subst hCS; subst hT
  have h1 : q₀ - q₁ > 0 := by linarith
  nlinarith [mul_pos ht h1]