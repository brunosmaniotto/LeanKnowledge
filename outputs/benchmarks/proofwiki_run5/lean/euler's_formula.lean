import Mathlib

open Complex

theorem euler_formula (z : ℂ) : exp (I * z) = cos z + I * sin z := by
  rw [mul_comm I z, Complex.exp_mul_I, mul_comm (sin z) I]