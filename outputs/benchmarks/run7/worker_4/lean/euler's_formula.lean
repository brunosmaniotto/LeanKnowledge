import Mathlib

open Complex

theorem euler_formula (z : ℂ) : exp (I * z) = cos z + I * sin z := by
  -- First rewrite I*z as z*I using commutativity
  rw [mul_comm I z]
  -- Apply the standard identity for exp(z*I)
  rw [exp_mul_I]
  -- The result is cos z + sin z * I, but we need cos z + I * sin z
  -- These are equal by commutativity of multiplication
  rw [mul_comm (sin z) I]