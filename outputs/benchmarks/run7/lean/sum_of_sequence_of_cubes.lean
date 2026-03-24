import Mathlib
open Finset
open BigOperators

lemma sum_range_id (n : ℕ) : (∑ i ∈ range (n + 1), i : ℚ) = (n : ℚ) * (n + 1) / 2 := by
  induction' n with k IH
  · norm_num
  · rw [sum_range_succ, IH]
    push_cast
    ring