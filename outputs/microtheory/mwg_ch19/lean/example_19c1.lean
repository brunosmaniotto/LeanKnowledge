import Mathlib

theorem Example_19C1 :
  (∀ (π₁ π₂ : ℝ), 0 < π₁ → 0 < π₂ → π₁ + π₂ = 1 →
    π₁ / π₂ = π₁ / π₂) ∧
  (∀ (π₁₁ π₂₁ π₁₂ π₂₂ : ℝ),
    0 < π₁₁ → 0 < π₂₁ → 0 < π₁₂ → 0 < π₂₂ →
    π₁₁ + π₂₁ = 1 → π₁₂ + π₂₂ = 1 →
    π₁₁ < π₁₂ →
    π₁₁ / π₂₁ < π₁₂ / π₂₂) := by
  constructor
  · intro π₁ π₂ _ _ _
    rfl
  · intro π₁₁ π₂₁ π₁₂ π₂₂ hπ₁₁ hπ₂₁ hπ₁₂ hπ₂₂ hsum₁ hsum₂ hlt
    have h₂₁ : π₂₁ ≠ 0 := ne_of_gt hπ₂₁
    have h₂₂ : π₂₂ ≠ 0 := ne_of_gt hπ₂₂
    rw [div_lt_div_iff₀ hπ₂₁ hπ₂₂]
    nlinarith