import Mathlib

theorem infinite_primes : Set.Infinite {p | Nat.Prime p} :=
  Nat.infinite_setOf_prime