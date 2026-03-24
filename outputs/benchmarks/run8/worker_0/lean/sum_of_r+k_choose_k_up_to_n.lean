import Mathlib

open Finset
open Nat

theorem sum_choose_eq (r n : ℕ) : (∑ k ∈ range (n + 1), (r + k).choose k) = (r + n + 1).choose n := by
  induction n with
  | zero => simp
  | succ m IH =>
      rw [sum_range_succ, IH]
      have H : r + m + 1 = r + (m + 1) := by ring
      rw [H, ← Nat.choose_succ_succ (r + (m + 1)) m]