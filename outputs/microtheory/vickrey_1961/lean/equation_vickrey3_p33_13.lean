import Mathlib

theorem Equation_Vickrey3_p33_13
    (Z1 Z2 X a v2 Z1' : ℝ)
    (eq9 : v2 = Z1 + X - a - Z2 * Z1')
    (eq11 : v2 + Z2 * Z1' + Z2 = Z1 + X - a + Z2) :
    Z2 * Z1' + Z2 = Z1 + X - a - v2 + Z2 := by
  linarith