import Mathlib

theorem linear_diophantine_iff (a b c : ℤ) : (∃ x y, a * x + b * y = c) ↔ (Int.gcd a b : ℤ) ∣ c := by
  constructor
  · intro h
    rcases h with ⟨x, y, h_eq⟩
    rw [← h_eq]
    have h1 : (Int.gcd a b : ℤ) ∣ a * x := (Int.gcd_dvd_left a b).mul_right x
    have h2 : (Int.gcd a b : ℤ) ∣ b * y := (Int.gcd_dvd_right a b).mul_right y
    exact dvd_add h1 h2
  · intro h
    rcases h with ⟨k, rfl⟩
    use k * Int.gcdA a b, k * Int.gcdB a b
    calc
      a * (k * Int.gcdA a b) + b * (k * Int.gcdB a b) = k * (a * Int.gcdA a b + b * Int.gcdB a b) := by ring
      _ = k * (Int.gcd a b : ℤ) := by rw [Int.gcd_eq_gcd_ab]
      _ = (Int.gcd a b : ℤ) * k := by ring