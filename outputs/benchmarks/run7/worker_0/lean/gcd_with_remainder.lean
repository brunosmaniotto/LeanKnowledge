import Mathlib

theorem gcd_with_remainder (a b q r : ℤ) (h : a = q * b + r) : Int.gcd a b = Int.gcd b r := by
  have r_eq : r = a - q * b := by linarith
  rw [r_eq]
  calc
    Int.gcd a b = Int.gcd b a := by rw [Int.gcd_comm]
    _ = Int.gcd b (a + (-q) * b) := by rw [Int.gcd_add_mul_right_right]
    _ = Int.gcd b (a - q * b) := by ring