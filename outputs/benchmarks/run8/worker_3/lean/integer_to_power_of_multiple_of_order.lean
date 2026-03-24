import Mathlib

open ZMod

theorem Integer_to_Power_of_Multiple_of_Order (a : ℤ) (n : ℕ) (hcop : a.gcd (n : ℤ) = 1) (c : ℕ) (hpos : 0 < c)
    (h_order : orderOf (a : ZMod n) = c) (k : ℕ) : a ^ k ≡ 1 [ZMOD (n : ℤ)] ↔ c ∣ k := by
  have h1 : a ^ k ≡ 1 [ZMOD n] ↔ (a : ZMod n) ^ k = 1 := by
    rw [← ZMod.intCast_eq_intCast_iff, Int.cast_pow, Int.cast_one]
  have h2 : (a : ZMod n) ^ k = 1 ↔ orderOf (a : ZMod n) ∣ k := by
    rw [orderOf_dvd_iff_pow_eq_one]
  rw [h1, h2, h_order]