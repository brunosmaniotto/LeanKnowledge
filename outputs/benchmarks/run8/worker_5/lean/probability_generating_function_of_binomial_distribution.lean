import Mathlib

open Finset
open BigOperators

theorem pgf_binomial (n : ℕ) (p s : ℝ) :
    ∑ k ∈ range (n + 1), (Nat.choose n k : ℝ) * p ^ k * (1 - p) ^ (n - k) * s ^ k = ((1 - p) + p * s) ^ n := by
  calc
    ∑ k ∈ range (n + 1), (Nat.choose n k : ℝ) * p ^ k * (1 - p) ^ (n - k) * s ^ k
        = ∑ k ∈ range (n + 1), (Nat.choose n k : ℝ) * (p * s) ^ k * (1 - p) ^ (n - k) := by
          refine Finset.sum_congr rfl fun k _ => ?_
          ring
    _ = (p * s + (1 - p)) ^ n := by
          rw [add_pow]
          refine Finset.sum_congr rfl fun k _ => ?_
          ring
    _ = ((1 - p) + p * s) ^ n := by ring