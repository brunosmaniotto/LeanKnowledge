import Mathlib

theorem prime_dvd_pow_iff (hp : Nat.Prime p) (a : ℤ) (n : ℕ) (hn : n > 0) :
    (p : ℤ) ∣ a ^ n ↔ (p : ℤ) ^ n ∣ a ^ n := by
  constructor
  · intro h
    have hp' : Prime (p : ℤ) := Nat.prime_iff_prime_int.mp hp
    have h1 : (p : ℤ) ∣ a := hp'.dvd_of_dvd_pow h
    obtain ⟨r, rfl⟩ := h1
    rw [mul_pow]
    exact ⟨r ^ n, by ring⟩
  · intro h
    have h3 : (p : ℤ) ∣ (p : ℤ) ^ n := by
      cases' n with n
      · exfalso; omega
      · rw [pow_succ]
        exact dvd_mul_left (p : ℤ) (p ^ n)
    exact dvd_trans h3 h