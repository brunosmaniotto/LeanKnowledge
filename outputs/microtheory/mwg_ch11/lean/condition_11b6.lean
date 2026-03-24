import Mathlib
open Topology

theorem Condition_11B6
    (φ₁ : ℝ → ℝ) (p_h h₁ : ℝ)
    (hφ_diff : DifferentiableAt ℝ φ₁ h₁)
    (h_nonneg : h₁ ≥ 0)
    (h_max : IsLocalMax (fun h => φ₁ h - p_h * h) h₁)
    (h_pos : h₁ > 0) :
    deriv φ₁ h₁ = p_h := by
  have hφ_deriv : HasDerivAt φ₁ (deriv φ₁ h₁) h₁ := hφ_diff.hasDerivAt
  have hlin : HasDerivAt (fun h => p_h * h) p_h h₁ := by
    have := (hasDerivAt_id h₁).const_mul p_h
    simp [mul_one] at this
    exact this
  have hobj : HasDerivAt (fun h => φ₁ h - p_h * h) (deriv φ₁ h₁ - p_h) h₁ := hφ_deriv.sub hlin
  have hderiv_zero : deriv (fun h => φ₁ h - p_h * h) h₁ = 0 := IsLocalMax.deriv_eq_zero h_max
  have := hobj.deriv
  linarith