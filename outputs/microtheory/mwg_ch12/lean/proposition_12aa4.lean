import Mathlib

theorem Proposition_12AA4
    (δ : ℝ) (hδ_pos : 0 < δ) (hδ_lt : δ < 1)
    (π₁ π₂ z₁ z₂ : ℝ)
    (hπ₁ : π₁ > z₁)
    (hπ₂ : π₂ > z₂) :
    ∃ v₁ v₂ : ℝ, (1 - δ) * v₁ < π₁ ∧ (1 - δ) * v₂ < π₂ := by
  have h1d : (1 - δ) > 0 := by linarith
  refine ⟨(π₁ + z₁) / 2 / (1 - δ), (π₂ + z₂) / 2 / (1 - δ), ?_, ?_⟩
  · rw [mul_div_cancel₀]
    · linarith
    · linarith
  · rw [mul_div_cancel₀]
    · linarith
    · linarith