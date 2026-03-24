import Mathlib

open Real
open Topology

theorem claim_2E_c :
    -- Part 1: Affine transforms preserve difference ratios
    (∀ (a b u₁ u₂ u₃ : ℝ), a > 0 → u₁ ≠ u₃ →
      (a * u₁ + b - (a * u₂ + b)) / (a * u₁ + b - (a * u₃ + b)) =
      (u₁ - u₂) / (u₁ - u₃)) ∧
    -- Part 2: ∃ a strictly monotone f that changes difference ratios
    (∃ f : ℝ → ℝ, StrictMono f ∧
      ∃ u₁ u₂ u₃ : ℝ, u₁ ≠ u₃ ∧
        (f u₁ - f u₂) * (u₁ - u₃) ≠ (u₁ - u₂) * (f u₁ - f u₃)) := by
  constructor
  · intro a b u₁ u₂ u₃ ha hne
    have hd : a * u₁ + b - (a * u₃ + b) ≠ 0 := by
      have : a * u₁ + b - (a * u₃ + b) = a * (u₁ - u₃) := by ring
      rw [this]; exact mul_ne_zero (ne_of_gt ha) (sub_ne_zero.mpr hne)
    exact (div_eq_div_iff hd (sub_ne_zero.mpr hne)).mpr (by ring)
  · refine ⟨exp, exp_strictMono, 0, 1, 2, by norm_num, ?_⟩
    simp only [exp_zero]
    intro h
    have he1 : (1 : ℝ) < exp 1 := by
      have := exp_strictMono (show (0 : ℝ) < 1 by norm_num)
      rwa [exp_zero] at this
    have hexp2 : exp 2 = exp 1 * exp 1 := by
      rw [show (2 : ℝ) = 1 + 1 by norm_num, exp_add]
    rw [hexp2] at h
    nlinarith [mul_pos (sub_pos.mpr he1) (sub_pos.mpr he1)]