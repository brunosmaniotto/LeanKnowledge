import Mathlib
open Topology

theorem Ramsey_Formula_22B1
    (p₁ p₂ : ℝ)
    (hp₁ : p₁ > 1) (hp₂ : p₂ > 1)
    (x₁ x₂ : ℝ) (dx₁ dx₂ : ℝ)
    (hx₁_pos : x₁ > 0) (hx₂_pos : x₂ > 0)
    (hdx₁_neg : dx₁ < 0) (hdx₂_neg : dx₂ < 0)
    (ε₁ ε₂ : ℝ)
    (hε₁_def : ε₁ = -(p₁ / x₁) * dx₁)
    (hε₂_def : ε₂ = -(p₂ / x₂) * dx₂)
    (lam : ℝ)
    (hfoc₁ : (p₁ - 1) * dx₁ = (lam - 1) * x₁)
    (hfoc₂ : (p₂ - 1) * dx₂ = (lam - 1) * x₂)
    (t₁ t₂ : ℝ)
    (ht₁_def : t₁ = (p₁ - 1) / p₁)
    (ht₂_def : t₂ = (p₂ - 1) / p₂) :
    t₁ * ε₁ = t₂ * ε₂ := by
  have hp₁_ne : p₁ ≠ 0 := by linarith
  have hp₂_ne : p₂ ≠ 0 := by linarith
  have hx₁_ne : x₁ ≠ 0 := by linarith
  have hx₂_ne : x₂ ≠ 0 := by linarith
  suffices h : t₁ * ε₁ = 1 - lam ∧ t₂ * ε₂ = 1 - lam by linarith [h.1, h.2]
  constructor
  · rw [ht₁_def, hε₁_def]
    field_simp
    nlinarith [mul_comm (p₁ - 1) dx₁, mul_comm (lam - 1) x₁]
  · rw [ht₂_def, hε₂_def]
    field_simp
    nlinarith [mul_comm (p₂ - 1) dx₂, mul_comm (lam - 1) x₂]