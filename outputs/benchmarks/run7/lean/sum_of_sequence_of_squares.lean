import Mathlib

open Finset
open BigOperators

theorem sum_of_squares (n : ℕ) : ∑ i ∈ range (n + 1), i ^ 2 = (n * (n + 1) * (2 * n + 1)) / 6 := by
  have H : 6 * ∑ i ∈ range (n + 1), i ^ 2 = n * (n + 1) * (2 * n + 1) := by
    induction' n with k IH
    · norm_num
    · rw [sum_range_succ, mul_add, IH]
      ring
  rw [← H, Nat.mul_div_cancel_left _ (by norm_num)]