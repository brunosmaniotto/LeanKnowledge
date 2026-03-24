import Mathlib

theorem claim_A2_3_6_e (d1 d2 : ℝ) (hd1 : d1 ≠ 0) (hd2 : d2 ≠ 0) :
    (d2 / d1) * (-(d1 / d2)) = -1 := by
  field_simp