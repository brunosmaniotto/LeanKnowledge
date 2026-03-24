import Mathlib

theorem Real.mul_well_defined (a1 a2 b1 b2 : ℝ) (ha : a1 = a2) (hb : b1 = b2) : a1 * b1 = a2 * b2 := by
  rw [ha, hb]