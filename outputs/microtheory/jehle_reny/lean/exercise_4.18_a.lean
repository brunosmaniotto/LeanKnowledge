import Mathlib

noncomputable section

structure ConstantElasticityModel where
  y0 : ℝ
  CS : ℝ
  η : ℝ
  hy0_pos : 0 < y0
  hη_ne_one : η ≠ 1

noncomputable def compensatingVariation (m : ConstantElasticityModel) : ℝ :=
  m.y0 * ((-m.CS / m.y0 * (1 - m.η) + 1) ^ ((1 : ℝ) / (1 - m.η))) - m.y0

theorem Exercise_4_18_a (m : ConstantElasticityModel) :
    compensatingVariation m =
      m.y0 * ((-m.CS / m.y0 * (1 - m.η) + 1) ^ ((1 : ℝ) / (1 - m.η))) - m.y0 := by
  rfl