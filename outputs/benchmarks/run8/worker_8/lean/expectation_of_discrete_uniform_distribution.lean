import Mathlib
open Finset
open BigOperators
open Real

lemma sum_range_succ_eq (n : ℕ) : ∑ k ∈ range (n + 1), (k : ℝ) = (n : ℝ) * (n + 1) / 2 := by
  induction' n with m IH
  · norm_num
  · rw [sum_range_succ, IH]
    push_cast
    ring