import Mathlib

open Real
open Topology

noncomputable section

/-- Verifying Theorem A2.6 for Cobb-Douglas: for f(x₁,x₂) = Ax₁^α x₂^β
    with α + β = 1, ∂f(tx)/∂x₁ = ∂f(x)/∂x₁ because t^(α+β-1) = t^0 = 1. -/
theorem Example_A2_4
    (A α β : ℝ) (hα : 0 < α) (hβ : 0 < β)
    (hab : α + β = 1)
    (x₁ x₂ t : ℝ) (hx₁ : 0 < x₁) (hx₂ : 0 < x₂) (ht : 0 < t) :
    -- Scaling exponent vanishes: t^(α+β-1) = t^0 = 1
    t ^ (α + β - 1) = 1 ∧
    -- Derivative scaling factor is 1: t^(α-1) · t^β = 1
    t ^ (α - 1) * t ^ β = 1 ∧
    -- Full derivative invariance: ∂f(tx)/∂x₁ = ∂f(x)/∂x₁
    α * A * (t * x₁) ^ (α - 1) * (t * x₂) ^ β =
      α * A * x₁ ^ (α - 1) * x₂ ^ β := by
  have h0 : α + β - 1 = 0 := by linarith
  have h0' : α - 1 + β = 0 := by linarith
  have scaling : t ^ (α - 1) * t ^ β = 1 := by
    rw [← rpow_add ht, h0', rpow_zero]
  refine ⟨by rw [h0, rpow_zero], scaling, ?_⟩
  -- (a * b) ^ z = a ^ z * b ^ z for positive bases
  have base_mul {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (z : ℝ) :
      (a * b) ^ z = a ^ z * b ^ z := by
    rw [rpow_def_of_pos (mul_pos ha hb), rpow_def_of_pos ha, rpow_def_of_pos hb,
        log_mul (ne_of_gt ha) (ne_of_gt hb), add_mul, exp_add]
  rw [base_mul ht hx₁, base_mul ht hx₂]
  -- Rearrange and cancel the t-factors using scaling
  have elim (p q r s u : ℝ) (hpq : p * q = 1) :
      u * (p * r) * (q * s) = u * r * s := by
    calc u * (p * r) * (q * s) = u * (p * q) * (r * s) := by ring
      _ = u * 1 * (r * s) := by rw [hpq]
      _ = u * r * s := by ring
  exact elim _ _ _ _ _ scaling