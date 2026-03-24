import Mathlib

theorem Equation_Vickrey3_p35_21 (x r1 r2 : ℝ) (h1 : x ≠ r1) (h2 : x ≠ r2) :
    (r2 - r1) / ((x - r1) * (x - r2)) = 1 / (x - r2) - 1 / (x - r1) := by
  have h1' : x - r1 ≠ 0 := sub_ne_zero.mpr h1
  have h2' : x - r2 ≠ 0 := sub_ne_zero.mpr h2
  field_simp
  ring