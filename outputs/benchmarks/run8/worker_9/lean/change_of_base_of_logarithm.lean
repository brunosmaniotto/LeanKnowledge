import Mathlib

open Real

theorem change_of_base (a b x : ℝ) (ha : 0 < a) (ha1 : a ≠ 1) (hb : 0 < b) (hb1 : b ≠ 1) (hx : 0 < x) :
    logb b x = logb a x / logb a b := by
  have hloga : Real.log a ≠ 0 := by
    intro h
    have H : a = 1 := by rw [← exp_log ha, h, exp_zero]
    exact ha1 H
  have hlogb : Real.log b ≠ 0 := by
    intro h
    have H : b = 1 := by rw [← exp_log hb, h, exp_zero]
    exact hb1 H
  unfold logb
  field_simp [hloga, hlogb]