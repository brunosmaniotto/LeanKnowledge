import Mathlib

open Finset
open BigOperators

theorem sum_up_down_equals_square (n : ℕ) :
    (∑ i ∈ range (n + 1), i) + (∑ i ∈ range n, i) = n ^ 2 := by
  induction' n with k IH
  · simp
  · calc
      (∑ i ∈ range (k + 2), i) + (∑ i ∈ range (k + 1), i) =
          ((∑ i ∈ range (k + 1), i) + (k + 1)) + ((∑ i ∈ range k, i) + k) := by
            rw [sum_range_succ, sum_range_succ]
      _ = ((∑ i ∈ range (k + 1), i) + (∑ i ∈ range k, i)) + (k + 1 + k) := by ring
      _ = k ^ 2 + (k + 1 + k) := by rw [IH]
      _ = k ^ 2 + 2 * k + 1 := by ring
      _ = (k + 1) ^ 2 := by ring