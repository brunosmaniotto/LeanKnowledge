import Mathlib

theorem multiplicative_ordering (x y z : ℤ) (hz : 0 < z) :
    (x < y ↔ z * x < z * y) ∧ (x ≤ y ↔ z * x ≤ z * y) := by
  constructor
  · constructor
    · intro h
      exact mul_lt_mul_of_pos_left h hz
    · intro h
      exact lt_of_mul_lt_mul_left h hz.le
  · constructor
    · intro h
      exact mul_le_mul_of_nonneg_left h hz.le
    · intro h
      exact le_of_mul_le_mul_left h hz