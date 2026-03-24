import Mathlib

open Set
open intervalIntegral
open Topology
set_option linter.unusedVariables false

noncomputable section

noncomputable def U (t₁ : ℝ) : ℝ := ∫ t₂ in (0:ℝ)..1, if t₁ > t₂ then t₁ - t₂ else 0

lemma U_eq {t₁ : ℝ} (ht : t₁ ∈ Icc (1:ℝ) 2) : U t₁ = t₁ - 1/2 := by
  dsimp [U]
  have h01 : (0:ℝ) ≤ 1 := by norm_num
  have h_integrand_eq : (∫ t₂ in (0:ℝ)..1, (if t₁ > t₂ then t₁ - t₂ else 0)) = ∫ t₂ in (0:ℝ)..1, (t₁ - t₂) := by
    refine integral_congr fun t₂ ht₂ => ?_
    have : t₂ ∈ Icc (0:ℝ) 1 := by rwa [uIcc_of_le h01] at ht₂
    have h_t₁_ge_t₂ : t₁ ≥ t₂ := by
      have h1 : (1:ℝ) ≤ t₁ := ht.left
      have h2 : t₂ ≤ 1 := this.right
      linarith
    by_cases h : t₁ > t₂
    · simp [h]
    · have : t₁ = t₂ := by linarith
      simp [h, this]
  rw [h_integrand_eq]
  calc
    ∫ t₂ in (0:ℝ)..1, (t₁ - t₂) = (∫ t₂ in (0:ℝ)..1, t₁) - ∫ t₂ in (0:ℝ)..1, t₂ :=
      integral_sub (continuous_const.intervalIntegrable _ _) (continuous_id.intervalIntegrable _ _)
    _ = ((1:ℝ) - (0:ℝ)) • t₁ - ((1:ℝ)^2 - (0:ℝ)^2)/2 := by rw [integral_const, integral_id]
    _ = (1 • t₁) - (1/2 : ℝ) := by norm_num
    _ = t₁ - 1/2 := by simp