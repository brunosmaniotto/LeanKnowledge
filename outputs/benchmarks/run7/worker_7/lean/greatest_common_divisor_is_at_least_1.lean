import Mathlib

/-- The greatest common divisor of two nonzero integers is at least 1. -/
theorem gcd_ge_one (a b : ℤ) (ha : a ≠ 0) (hb : b ≠ 0) : 1 ≤ Int.gcd a b :=
  Int.gcd_pos_of_ne_zero_left b ha