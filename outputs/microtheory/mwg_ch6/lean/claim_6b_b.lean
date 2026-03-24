import Mathlib
open Topology

theorem Claim_6B_b (u₁ u₂ u₃ : ℝ) (h : u₂ < u₁) :
    ∃ ε : ℝ, 0 < ε ∧ ∀ p : ℝ, 0 ≤ p → p < ε →
      u₂ < (1 - p) * u₁ + p * u₃ := by
  by_cases hle : u₁ ≤ u₃
  · exact ⟨1, one_pos, fun p hp0 hp1 => by nlinarith⟩
  · push_neg at hle
    have hd : 0 < u₁ - u₃ := by linarith
    have hd2 : 0 < u₁ - u₂ := by linarith
    have h2d : 0 < 2 * (u₁ - u₃) := by linarith
    refine ⟨(u₁ - u₂) / (2 * (u₁ - u₃)), by positivity, fun p hp0 hp1 => ?_⟩
    have key : p * (2 * (u₁ - u₃)) < u₁ - u₂ := by
      rwa [lt_div_iff₀ h2d] at hp1
    nlinarith [mul_nonneg hp0 (le_of_lt hd)]