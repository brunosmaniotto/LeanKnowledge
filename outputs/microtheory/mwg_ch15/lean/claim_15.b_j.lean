import Mathlib

theorem second_welfare_theorem_fails_without_strong_monotonicity :
    ∃ (u₁ u₂ : ℝ × ℝ → ℝ) (ω₁ ω₂ : ℝ × ℝ),
      -- (i) u₁ is NOT strongly monotone
      (∃ x y : ℝ × ℝ, x.1 ≤ y.1 ∧ x.2 ≤ y.2 ∧ (x.1 < y.1 ∨ x.2 < y.2) ∧ u₁ y ≤ u₁ x) ∧
      -- (ii) ω is Pareto optimal
      (∀ x₁ x₂ : ℝ × ℝ,
        x₁.1 + x₂.1 = ω₁.1 + ω₂.1 → x₁.2 + x₂.2 = ω₁.2 + ω₂.2 →
        ¬(u₁ x₁ ≥ u₁ ω₁ ∧ u₂ x₂ > u₂ ω₂)) ∧
      -- (iii) SWT mechanism fails: consumer 1 globally satiated at ω₁
      (∀ x : ℝ × ℝ, u₁ x ≤ u₁ ω₁) := by
  refine ⟨fun x => -(x.1 - 1) ^ 2 - (x.2 - 1) ^ 2,
          fun x => x.1 + x.2,
          (1, 1), (1, 1), ?_, ?_, ?_⟩
  · refine ⟨(1, 1), (2, 1), ?_, ?_, Or.inl ?_, ?_⟩ <;> dsimp only <;> norm_num
  · intro x₁ x₂ h1 h2 ⟨hu1, hu2⟩
    dsimp only at *
    have hx1a : x₁.1 = 1 := by nlinarith [sq_nonneg (x₁.1 - 1), sq_nonneg (x₁.2 - 1)]
    have hx1b : x₁.2 = 1 := by nlinarith [sq_nonneg (x₁.1 - 1), sq_nonneg (x₁.2 - 1)]
    linarith
  · intro x; dsimp only
    nlinarith [sq_nonneg (x.1 - 1), sq_nonneg (x.2 - 1)]