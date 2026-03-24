import Mathlib

open Nat

theorem sum_divisors_eq_sum_reciprocal_divisors {M : Type*} [AddCommMonoid M] (n : ℕ) (f : ℕ → M) :
    ∑ d ∈ divisors n, f d = ∑ d ∈ divisors n, f (n / d) := by
  simpa using Nat.sum_divisors_antidiagonal (fun d _ => f d) n