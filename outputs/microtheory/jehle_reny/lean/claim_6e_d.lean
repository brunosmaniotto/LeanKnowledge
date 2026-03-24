import Mathlib
open Topology

theorem claim_6E_d
    (W : ℝ → ℝ → ℝ)
    (hW_mono1 : ∀ u₁ u₂ v₁, u₁ < v₁ → W u₁ u₂ < W v₁ u₂)
    (hW_mono2 : ∀ u₁ u₂ v₂, u₂ < v₂ → W u₁ u₂ < W u₁ v₂)
    (hW_inv : ∀ u₁ u₂ v₁ v₂ b, b > 0 → W u₁ u₂ = W v₁ v₂ →
      W (b * u₁) (b * u₂) = W (b * v₁) (b * v₂)) :
    (∀ u₁ u₂ v₁ v₂, W u₁ u₂ = W v₁ v₂ → u₁ < v₁ → v₂ < u₂) ∧
    (∀ u₁ u₂ v₁ v₂ b, b > 0 → W u₁ u₂ = W v₁ v₂ → u₁ ≠ v₁ →
      W (b * u₁) (b * u₂) = W (b * v₁) (b * v₂) ∧
      (b * v₂ - b * u₂) / (b * v₁ - b * u₁) = (v₂ - u₂) / (v₁ - u₁)) := by
  constructor
  · -- Negatively sloped: strict monotonicity forces trade-off on indifference curves
    intro u₁ u₂ v₁ v₂ hW hu
    by_contra h
    push_neg at h
    have h1 := hW_mono1 u₁ u₂ v₁ hu
    rcases h.eq_or_lt with heq | hlt
    · rw [heq] at h1 hW; linarith
    · linarith [hW_mono2 v₁ u₂ v₂ hlt]
  · -- Radially parallel: invariance preserves indifference; b cancels in slope ratio
    intro u₁ u₂ v₁ v₂ b hb hW hne
    have hne' : v₁ - u₁ ≠ 0 := sub_ne_zero.mpr hne.symm
    have hbne : b * v₁ - b * u₁ ≠ 0 := by
      have : b * v₁ - b * u₁ = b * (v₁ - u₁) := by ring
      rw [this]; exact mul_ne_zero hb.ne' hne'
    exact ⟨hW_inv _ _ _ _ _ hb hW, (div_eq_div_iff hbne hne').mpr (by ring)⟩