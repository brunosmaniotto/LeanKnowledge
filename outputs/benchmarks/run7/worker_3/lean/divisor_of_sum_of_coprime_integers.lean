import Mathlib

theorem divisor_of_sum_of_coprime (a b c : ℕ) (ha : a > 0) (hb : b > 0) (hc : c > 0) (h : Nat.Coprime a b) (hdiv : c ∣ a + b) :
    Nat.Coprime a c ∧ Nat.Coprime b c := by
  constructor
  · apply Nat.eq_one_of_dvd_one
    have h1 : Nat.gcd a c ∣ a := Nat.gcd_dvd_left a c
    have h2 : Nat.gcd a c ∣ c := Nat.gcd_dvd_right a c
    have h3 : Nat.gcd a c ∣ a + b := dvd_trans h2 hdiv
    have h4 : Nat.gcd a c ∣ b := (Nat.dvd_add_right h1).mp h3
    have h5 : Nat.gcd a c ∣ Nat.gcd a b := Nat.dvd_gcd h1 h4
    rwa [h] at h5
  · apply Nat.eq_one_of_dvd_one
    have h1 : Nat.gcd b c ∣ b := Nat.gcd_dvd_left b c
    have h2 : Nat.gcd b c ∣ c := Nat.gcd_dvd_right b c
    have h3 : Nat.gcd b c ∣ a + b := dvd_trans h2 hdiv
    have h4 : Nat.gcd b c ∣ a := (Nat.dvd_add_left h1).mp h3
    have h5 : Nat.gcd b c ∣ Nat.gcd a b := Nat.dvd_gcd h4 h1
    rwa [h] at h5