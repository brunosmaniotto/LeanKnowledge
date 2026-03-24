import Mathlib

theorem euclids_lemma (a b c : ℤ) (h_div : a ∣ b * c) (h_coprime : IsCoprime a b) : a ∣ c :=
  h_coprime.dvd_of_dvd_mul_left h_div