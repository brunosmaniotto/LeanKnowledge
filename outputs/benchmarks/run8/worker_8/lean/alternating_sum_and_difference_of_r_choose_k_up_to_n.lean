import Mathlib

open Finset
open BigOperators

theorem alternating_sum_choose (r n : ℕ) :
    ∑ k ∈ range (n + 1), (-1 : ℤ) ^ k * (Nat.choose (r + 1) k) = (-1 : ℤ) ^ n * (Nat.choose r n) := by
  induction' n with m IH
  · simp
  · rw [sum_range_succ, IH]
    have h : (-1 : ℤ) ^ (m + 1) = -(-1) ^ m := by simp [pow_succ]
    rw [h]
    push_cast
    rw [Nat.choose_succ_succ r m]
    push_cast
    ring