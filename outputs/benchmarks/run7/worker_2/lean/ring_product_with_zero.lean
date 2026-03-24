import Mathlib

variable (R : Type) [Ring R]

theorem ring_zero_product (x : R) : (0 : R) * x = 0 ∧ 0 = x * 0 := by
  exact ⟨zero_mul x, (mul_zero x).symm⟩