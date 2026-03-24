import Mathlib

theorem int_dvd_of_coprime_dvd (a b c : ℤ) (h : Int.gcd a b = 1) (ha : a ∣ c) (hb : b ∣ c) : a * b ∣ c :=
  (Int.isCoprime_iff_gcd_eq_one.mpr h).mul_dvd ha hb