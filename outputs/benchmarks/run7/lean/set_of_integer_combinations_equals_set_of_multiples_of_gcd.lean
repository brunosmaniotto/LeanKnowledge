import Mathlib

theorem gcd_dvd_iff_exists_linear_combination (a b c : ℤ) :
    (Int.gcd a b : ℤ) ∣ c ↔ ∃ x y : ℤ, c = x * a + y * b := by
  constructor
  · intro h
    rcases h with ⟨k, rfl⟩
    rw [Int.gcd_eq_gcd_ab a b]
    exact ⟨k * Int.gcdA a b, k * Int.gcdB a b, by ring⟩
  · intro h
    rcases h with ⟨x, y, rfl⟩
    have h1 : (Int.gcd a b : ℤ) ∣ x * a := (Int.gcd_dvd_left a b).mul_left x
    have h2 : (Int.gcd a b : ℤ) ∣ y * b := (Int.gcd_dvd_right a b).mul_left y
    exact dvd_add h1 h2