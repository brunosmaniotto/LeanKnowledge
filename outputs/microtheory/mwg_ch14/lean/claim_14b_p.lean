import Mathlib

structure SufficientStatCondition where
  f_H : ℝ → ℝ → ℝ
  f_L : ℝ → ℝ → ℝ
  f1_H : ℝ → ℝ
  f1_L : ℝ → ℝ
  f2 : ℝ → ℝ → ℝ
  factor_H : ∀ π y, f_H π y = f1_H π * f2 y π
  factor_L : ∀ π y, f_L π y = f1_L π * f2 y π
  f2_pos : ∀ y π, 0 < f2 y π
  f1_H_pos : ∀ π, 0 < f1_H π

theorem sufficient_statistic_compensation_independent
    (S : SufficientStatCondition) :
    ∀ π y₁ y₂, S.f_L π y₁ / S.f_H π y₁ = S.f_L π y₂ / S.f_H π y₂ := by
  intro π y₁ y₂
  simp only [S.factor_L, S.factor_H]
  have h1 := S.f2_pos y₁ π
  have h2 := S.f2_pos y₂ π
  have h3 := S.f1_H_pos π
  have hd1 : S.f1_H π * S.f2 y₁ π ≠ 0 := ne_of_gt (mul_pos h3 h1)
  have hd2 : S.f1_H π * S.f2 y₂ π ≠ 0 := ne_of_gt (mul_pos h3 h2)
  field_simp