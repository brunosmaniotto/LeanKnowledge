import Mathlib

theorem claim_14AA_a : ∃ (c₁ c₂ c₃ p₁ p₂ p₃ : ℝ),
    0 ≤ p₁ ∧ p₁ ≤ 1 ∧ 0 ≤ p₂ ∧ p₂ ≤ 1 ∧ 0 ≤ p₃ ∧ p₃ ≤ 1 ∧
    c₁ < c₂ ∧ c₂ < c₃ ∧ p₁ < p₂ ∧ p₂ < p₃ ∧
    ∀ wL wH : ℝ,
      ¬ (p₂ * wH + (1 - p₂) * wL - c₂ ≥ p₁ * wH + (1 - p₁) * wL - c₁ ∧
         p₂ * wH + (1 - p₂) * wL - c₂ ≥ p₃ * wH + (1 - p₃) * wL - c₃) := by
  use 0, 2, 3, 1/2, 3/4, 1
  refine ⟨by norm_num, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num,
    by norm_num, by norm_num, by norm_num, by norm_num, ?_⟩
  intro wL wH ⟨h1, h2⟩
  linarith