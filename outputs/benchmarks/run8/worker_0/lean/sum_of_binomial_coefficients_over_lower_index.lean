import Mathlib

theorem sum_binomial_eq_pow_two (n : ℕ) : ∑ i ∈ Finset.range (n + 1), Nat.choose n i = 2 ^ n :=
  Nat.sum_range_choose n