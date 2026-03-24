import Mathlib
open scoped symmDiff
open Topology

theorem Rybczynski_theorem
    (a₁ a₂ b₁ b₂ : ℝ)
    (ha₁ : 0 < a₁) (ha₂ : 0 < a₂) (hb₁ : 0 < b₁) (hb₂ : 0 < b₂)
    (hintensity : a₁ * b₂ > a₂ * b₁)
    (L K : ℝ)
    (x₁ x₂ : ℝ)
    (hL : a₁ * x₁ + a₂ * x₂ = L)
    (hK : b₁ * x₁ + b₂ * x₂ = K)
    (ΔL : ℝ) (hΔL : 0 < ΔL)
    (x₁' x₂' : ℝ)
    (hL' : a₁ * x₁' + a₂ * x₂' = L + ΔL)
    (hK' : b₁ * x₁' + b₂ * x₂' = K) :
    x₁' > x₁ ∧ x₂' < x₂ := by
  have key1 : a₁ * (x₁' - x₁) + a₂ * (x₂' - x₂) = ΔL := by linarith
  have key2 : b₁ * (x₁' - x₁) + b₂ * (x₂' - x₂) = 0 := by linarith
  have elim : (a₂ * b₁ - a₁ * b₂) * (x₂' - x₂) = b₁ * ΔL := by nlinarith
  have hcoeff_neg : a₂ * b₁ - a₁ * b₂ < 0 := by linarith
  have hrhs_pos : 0 < b₁ * ΔL := mul_pos hb₁ hΔL
  have hx₂_dec : x₂' - x₂ < 0 := by
    by_contra h
    push_neg at h
    have : (a₂ * b₁ - a₁ * b₂) * (x₂' - x₂) ≤ 0 :=
      mul_nonpos_of_nonpos_of_nonneg (le_of_lt hcoeff_neg) h
    linarith
  have hx₁_inc : x₁' - x₁ > 0 := by
    have h1 : b₂ * (x₂' - x₂) < 0 := mul_neg_of_pos_of_neg hb₂ hx₂_dec
    have h4 : 0 < b₁ * (x₁' - x₁) := by linarith
    nlinarith
  exact ⟨by linarith, by linarith⟩