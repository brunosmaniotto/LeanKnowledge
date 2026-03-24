import Mathlib

theorem euclids_lemma (a b c : ℤ) (h_div : a ∣ b * c) (h_coprime : Int.gcd a b = 1) : a ∣ c := by
  have h_coprime' : IsCoprime a b := by
    rw [Int.isCoprime_iff_gcd_eq_one]
    exact h_coprime
  exact h_coprime'.dvd_of_dvd_mul_left h_div