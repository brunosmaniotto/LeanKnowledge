import Mathlib

theorem Int.zero_is_mul_zero : (∀ x : ℤ, x * 0 = 0) ∧ (∀ x : ℤ, 0 * x = 0) :=
  ⟨Int.mul_zero, Int.zero_mul⟩