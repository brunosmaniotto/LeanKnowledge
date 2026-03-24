import Mathlib

open Real

theorem arrow_pratt_cara (a : ℝ) (ha : 0 < a) (x : ℝ) :
    -(-(a ^ 2) * exp (-a * x)) / (a * exp (-a * x)) = a := by
  have hexp : exp (-a * x) > 0 := exp_pos _
  have ha_ne : a ≠ 0 := ne_of_gt ha
  have hae : a * exp (-a * x) ≠ 0 := mul_ne_zero ha_ne (ne_of_gt hexp)
  field_simp