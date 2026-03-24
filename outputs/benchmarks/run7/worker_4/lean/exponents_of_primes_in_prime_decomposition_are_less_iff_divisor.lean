import Mathlib.Data.Nat.Factorization.Basic

theorem Exponents_of_Primes_in_Prime_Decomposition_are_Less_iff_Divisor (a b : ℕ) (ha : a > 0) (hb : b > 0) :
    a ∣ b ↔ ∀ p, (Nat.factorization a) p ≤ (Nat.factorization b) p :=
  (Nat.factorization_le_iff_dvd (ne_of_gt ha) (ne_of_gt hb)).symm