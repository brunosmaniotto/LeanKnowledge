import Mathlib
open Topology

theorem Claim_11B_c
    (φ₁ φ₂ : ℝ → ℝ)
    (hφ₁ : Differentiable ℝ φ₁)
    (hφ₂ : Differentiable ℝ φ₂)
    (h₀ : ℝ)
    (hh₀_pos : h₀ > 0)
    (h_foc : deriv φ₁ h₀ + deriv φ₂ h₀ = 0)
    (h_neg_ext : deriv φ₂ h₀ < 0) :
    deriv φ₁ h₀ = -(deriv φ₂ h₀) ∧ deriv φ₁ h₀ > 0 := by
  constructor
  · linarith
  · linarith