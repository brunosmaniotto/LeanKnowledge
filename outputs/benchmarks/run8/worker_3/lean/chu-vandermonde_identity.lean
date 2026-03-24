import Mathlib

open Finset

theorem chu_vandermonde (r s n : ℕ) : (r + s).choose n = ∑ k ∈ range (n + 1), r.choose k * s.choose (n - k) := by
  rw [Nat.add_choose_eq]
  rw [Finset.Nat.sum_antidiagonal_eq_sum_range_succ (fun i j => r.choose i * s.choose j) n]