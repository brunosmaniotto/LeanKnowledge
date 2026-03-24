import Mathlib

theorem prime_not_divisor_implies_coprime (p : ℕ) (a : ℤ) (h_p_prime : Nat.Prime p)
    (h_p_not_dvd_a : ¬((p : ℤ) ∣ a)) : IsCoprime (p : ℤ) a := by
  rw [Int.isCoprime_iff_gcd_eq_one]
  let d := Int.gcd (p : ℤ) a
  have h_left : (d : ℤ) ∣ (p : ℤ) := Int.gcd_dvd_left (p : ℤ) a
  have h_right : (d : ℤ) ∣ a := Int.gcd_dvd_right (p : ℤ) a
  have h_nat : d ∣ p := mod_cast h_left
  rcases h_p_prime.eq_one_or_self_of_dvd d h_nat with h | h
  · exact h
  · rw [h] at h_right
    exfalso
    exact h_p_not_dvd_a h_right