import Mathlib

open Finset
open Nat

theorem three_mul_sum_Icc_j_jplus_one (n : ℕ) : 3 * ∑ j ∈ Icc 1 n, j * (j + 1) = n * (n + 1) * (n + 2) := by
  induction n with
  | zero => simp
  | succ k IH =>
      have h : 1 ≤ k + 1 := by omega
      rw [Finset.sum_Icc_succ_top (f := fun j => j * (j + 1)) h]
      rw [mul_add, IH]
      ring