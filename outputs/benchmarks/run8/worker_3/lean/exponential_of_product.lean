import Mathlib

theorem exp_of_product (x y : ℝ) : Real.exp (x * y) = (Real.exp y) ^ x := by
  rw [mul_comm, Real.exp_mul]