import Mathlib

open Nat

theorem sum_of_totient_over_divisors_eq (n : ℕ) : (∑ d ∈ divisors n, totient d) = n :=
  Nat.sum_totient n