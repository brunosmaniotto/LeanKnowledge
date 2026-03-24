import Mathlib

open CharP

theorem finite_domain_char_prime_and_order (R : Type*) [CommRing R] [IsDomain R] [Fintype R] (n : ℕ) [CharP R n] (hn : n ≠ 0) :
    Nat.Prime n ∧ ∀ a : R, a ≠ 0 → addOrderOf a = n := by
  have prime_n : Nat.Prime n := CharP.char_is_prime R n
  constructor
  · exact prime_n
  · intro a ha
    have h_nsmul : n • a = 0 := by
      rw [nsmul_eq_mul, CharP.cast_eq_zero R n, zero_mul]
    have h_dvd : addOrderOf a ∣ n := addOrderOf_dvd_of_nsmul_eq_zero h_nsmul
    rcases prime_n.eq_one_or_self_of_dvd (addOrderOf a) h_dvd with (h_order | h_order)
    · have H := addOrderOf_nsmul_eq_zero a
      rw [h_order] at H
      rw [one_nsmul] at H
      exfalso; exact ha H
    · exact h_order