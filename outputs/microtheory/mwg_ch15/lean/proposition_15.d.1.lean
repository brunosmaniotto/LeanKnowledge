import Mathlib
open Topology

/-- Stolper-Samuelson Theorem: In a 2×2 production model, if the factor intensity
    assumption holds (det A > 0), then an increase in good 1's price raises the
    price of factor 1 (used more intensively in good 1) and lowers factor 2's price. -/
theorem Proposition_15_D_1
    (a₁₁ a₂₁ a₁₂ a₂₂ : ℝ)
    (h_pos_a₁₁ : 0 < a₁₁) (h_pos_a₂₁ : 0 < a₂₁)
    (h_pos_a₁₂ : 0 < a₁₂) (h_pos_a₂₂ : 0 < a₂₂)
    (h_det : a₁₁ * a₂₂ - a₁₂ * a₂₁ > 0) :
    let D := a₁₁ * a₂₂ - a₁₂ * a₂₁
    let dw₁ := a₂₂ / D
    let dw₂ := -a₁₂ / D
    0 < dw₁ ∧ dw₂ < 0 := by
  constructor
  · apply div_pos h_pos_a₂₂ h_det
  · apply div_neg_of_neg_of_pos (by linarith) h_det