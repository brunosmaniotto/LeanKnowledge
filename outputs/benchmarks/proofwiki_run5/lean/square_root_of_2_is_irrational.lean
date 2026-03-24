import Mathlib

lemma p_squared_eq_two_q_squared_implies_both_even (p q : ℤ) : p^2 = 2 * q^2 → (2 ∣ p ∧ 2 ∣ q) := by
  intro h
  constructor
  · -- First show 2 ∣ p
    have h1 : 2 ∣ p^2 := by
      rw [h]
      exact dvd_mul_right 2 (q^2)
    exact Prime.dvd_of_dvd_pow (Int.prime_two) h1
  · -- Now show 2 ∣ q
    have h2 : 2 ∣ p := Prime.dvd_of_dvd_pow (Int.prime_two) (by rw [h]; exact dvd_mul_right 2 (q^2))
    obtain ⟨k, hk⟩ := h2
    have h3 : (2 * k)^2 = 2 * q^2 := by rw [← hk, h]
    have h4 : 4 * k^2 = 2 * q^2 := by
      rw [← h3]
      ring
    have h5 : 2 * k^2 = q^2 := by linarith
    have h6 : 2 ∣ q^2 := by rw [← h5]; exact dvd_mul_right 2 (k^2)
    exact Prime.dvd_of_dvd_pow (Int.prime_two) h6