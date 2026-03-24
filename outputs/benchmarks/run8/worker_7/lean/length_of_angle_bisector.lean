import Mathlib

theorem length_of_angle_bisector (a b c d : ℝ) (ha : a ≠ 0) (h : b + c ≠ 0)
    (H : b ^ 2 * (a * c / (b + c)) + c ^ 2 * (a * b / (b + c)) = 
         d ^ 2 * a + (a * c / (b + c)) * (a * b / (b + c)) * a) :
    d ^ 2 = (b * c) / ((b + c) ^ 2) * (((b + c) ^ 2) - a ^ 2) := by
  field_simp [h] at H
  field_simp [h, pow_ne_zero 2 h]
  linarith [H]