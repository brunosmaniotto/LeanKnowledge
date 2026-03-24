import Mathlib

open Complex

theorem Eulers_Identity : exp (↑Real.pi * I) + 1 = 0 := by
  rw [exp_pi_mul_I]
  simp