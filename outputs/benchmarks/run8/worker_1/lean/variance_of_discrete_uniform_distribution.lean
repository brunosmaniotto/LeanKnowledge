import Mathlib

open Finset
open BigOperators

lemma sum_range_succ_eq (n : ℕ) : ∑ k ∈ range (n + 1), (k : ℚ) = (n : ℚ) * (n + 1) / 2 := by
  induction' n with m IH
  · norm_num
  · rw [sum_range_succ, IH, Nat.cast_succ]
    ring