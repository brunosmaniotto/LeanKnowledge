import Mathlib

open Real

/-- For the CES utility function u(x₁,x₂) = (x₁^ρ + x₂^ρ)^(1/ρ) with 0 ≠ ρ < 1,
    the FOCs of utility maximization reduce to:
    (1) x₁ = x₂ · (p₁/p₂)^(1/(ρ-1))
    (2) y = p₁·x₁ + p₂·x₂ (budget constraint) -/
theorem Claim_1E_a (ρ : ℝ) (hρ0 : ρ ≠ 0) (hρ1 : ρ < 1)
    (p₁ p₂ : ℝ) (hp₁ : 0 < p₁) (hp₂ : 0 < p₂)
    (x₁ x₂ : ℝ) (hx₁ : 0 < x₁) (hx₂ : 0 < x₂)
    (y : ℝ) (hbudget : y = p₁ * x₁ + p₂ * x₂)
    (hfoc : (x₁ / x₂) ^ (ρ - 1) = p₁ / p₂) :
    x₁ = x₂ * (p₁ / p₂) ^ (1 / (ρ - 1)) ∧ y = p₁ * x₁ + p₂ * x₂ := by
  refine ⟨?_, hbudget⟩
  have hρ_sub : ρ - 1 ≠ 0 := sub_ne_zero.mpr hρ1.ne
  have hx_nn : (0 : ℝ) ≤ x₁ / x₂ := (div_pos hx₁ hx₂).le
  have key : ((x₁ / x₂) ^ (ρ - 1)) ^ (1 / (ρ - 1)) = x₁ / x₂ := by
    rw [← rpow_mul hx_nn]
    have : (ρ - 1) * (1 / (ρ - 1)) = 1 := by field_simp
    rw [this, rpow_one]
  rw [hfoc] at key
  rw [eq_comm, div_eq_iff hx₂.ne', mul_comm] at key
  exact key