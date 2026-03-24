import Mathlib
open Finset BigOperators
open Topology

theorem claim_11B_k
    (φ₁ φ₂ : ℝ → ℝ)
    (h_star h_opt : ℝ)
    (h_star_nonneg : 0 ≤ h_star)
    (h_opt_nonneg : 0 ≤ h_opt)
    (h_opt_maximizes : ∀ h : ℝ, 0 ≤ h → φ₁ h + φ₂ h ≤ φ₁ h_opt + φ₂ h_opt) :
    ∀ h : ℝ, 0 ≤ h →
      φ₂ h + φ₁ h - φ₁ h_star ≤ φ₂ h_opt + φ₁ h_opt - φ₁ h_star := by
  intro h hh
  have := h_opt_maximizes h hh
  linarith