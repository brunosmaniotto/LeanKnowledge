import Mathlib

theorem lcm_mul_gcd_eq_product (a b : ℕ) : Nat.lcm a b * Nat.gcd a b = a * b := by
  rw [mul_comm, Nat.gcd_mul_lcm]