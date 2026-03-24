import Mathlib

theorem gcd_of_divisor (a b : ℤ) (ha : 0 < a) (hb : 0 < b) (h : a ∣ b) : (Int.gcd a b : ℤ) = a :=
  Int.gcd_eq_left (by linarith) h