import Mathlib

theorem int_no_zero_divisors (x y : ℤ) (h : x * y = 0) : x = 0 ∨ y = 0 := by
  exact eq_zero_or_eq_zero_of_mul_eq_zero h