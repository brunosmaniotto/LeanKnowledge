import Mathlib

theorem int_sub_ext_nat_sub (m n : ℕ) (h : m ≤ n) : (n : ℤ) - (m : ℤ) = (n - m : ℕ) := by
  rw [← Int.ofNat_sub h]