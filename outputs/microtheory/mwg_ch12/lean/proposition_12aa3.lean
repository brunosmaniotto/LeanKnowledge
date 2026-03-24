import Mathlib
open Topology

theorem Proposition_12AA3
    (deviation_gain : ℝ)
    (cooperation_gain : ℝ)
    (hdev : 0 < deviation_gain)
    (hcoop : 0 < cooperation_gain) :
    ∃ δ_bar : ℝ, 0 < δ_bar ∧ δ_bar < 1 ∧
      ∀ δ : ℝ, δ_bar < δ → δ < 1 →
        deviation_gain * (1 - δ) ≤ cooperation_gain * δ := by
  refine ⟨deviation_gain / (deviation_gain + cooperation_gain), ?_, ?_, ?_⟩
  · positivity
  · have hsum : (0 : ℝ) < deviation_gain + cooperation_gain := by linarith
    field_simp
    linarith
  · intro δ hδ_gt hδ_lt
    have hsum : (0 : ℝ) < deviation_gain + cooperation_gain := by linarith
    have hδ_pos : 0 < δ := by
      have : 0 < deviation_gain / (deviation_gain + cooperation_gain) := by positivity
      linarith
    have key : deviation_gain < δ * (deviation_gain + cooperation_gain) := by
      rw [show deviation_gain / (deviation_gain + cooperation_gain) < δ ↔
          deviation_gain < δ * (deviation_gain + cooperation_gain) from by
        constructor
        · intro h; field_simp at h; nlinarith
        · intro h; field_simp; nlinarith] at hδ_gt
      exact hδ_gt
    nlinarith