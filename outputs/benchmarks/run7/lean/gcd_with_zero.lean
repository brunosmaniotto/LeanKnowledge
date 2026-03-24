import Mathlib

theorem gcd_with_zero (a : ℤ) (h : a ≠ 0) : (Int.gcd a 0 : ℤ) = |a| := by
  calc
    (Int.gcd a 0 : ℤ) = (Int.natAbs a : ℤ) := by rw [Int.gcd_zero_right]
    _ = |a| := by rw [Int.abs_eq_natAbs]