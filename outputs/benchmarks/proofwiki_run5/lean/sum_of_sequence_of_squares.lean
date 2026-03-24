import Mathlib
open Finset
open BigOperators

theorem sum_sq (n : ℕ) : ∑ i ∈ range (n + 1), i ^ 2 = (n * (n + 1) * (2 * n + 1)) / 6 := by
  have h : 6 * (∑ i ∈ range (n + 1), i ^ 2) = n * (n + 1) * (2 * n + 1) := by
    induction' n with k IH
    · norm_num
    · rw [sum_range_succ, mul_add, IH]
      ring_nf
  have hpos : 0 < 6 := by norm_num
  calc
    ∑ i ∈ range (n + 1), i ^ 2 = (6 * (∑ i ∈ range (n + 1), i ^ 2)) / 6 := by
      rw [Nat.mul_div_cancel_left _ hpos]
    _ = (n * (n + 1) * (2 * n + 1)) / 6 := by rw [h]