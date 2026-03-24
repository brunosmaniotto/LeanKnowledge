import Mathlib

theorem Exercise_4_12_c
    (c₁ c₂ : ℝ)
    (hc₁_pos : 0 < c₁)
    (hc₂_pos : 0 < c₂)
    (h_cost : c₁ < c₂)
    (D : ℝ → ℝ)
    (hD_nonneg : ∀ p, 0 ≤ D p)
    (hD_pos : 0 < D c₂) :
    ∃ p : ℝ, c₁ < p ∧ p ≤ c₂ ∧
      0 < (p - c₁) * D p ∧
      ∀ p₂ : ℝ, p₂ < p → (p₂ - c₂) * D p₂ ≤ 0 := by
  refine ⟨c₂, h_cost, le_refl c₂, ?_, ?_⟩
  · exact mul_pos (by linarith) hD_pos
  · intro p₂ hp₂
    exact mul_nonpos_of_nonpos_of_nonneg (by linarith) (hD_nonneg p₂)