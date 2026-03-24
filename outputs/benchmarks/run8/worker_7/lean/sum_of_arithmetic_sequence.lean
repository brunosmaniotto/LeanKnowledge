import Mathlib

open Finset

theorem arith_sum_rat (a d : ℚ) (n : ℕ) :
    ∑ k ∈ range n, (a + k * d) = (n : ℚ) * (a + (n - 1 : ℚ) / 2 * d) := by
  induction' n with m IH
  · simp
  · rw [sum_range_succ, IH, Nat.cast_succ]
    push_cast
    ring