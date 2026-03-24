import Mathlib

theorem tau_of_prime_pow (p k : ℕ) (hp : p.Prime) : (Nat.divisors (p ^ k)).card = k + 1 := by
  simp [Nat.divisors_prime_pow hp]