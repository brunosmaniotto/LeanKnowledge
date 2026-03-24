import Mathlib

open BigOperators
open Finset

lemma sum_natural_numbers (n : ℕ) : 2 * ∑ i ∈ range n, (i+1) = n * (n+1) := by
  induction' n with k IH
  · simp
  · rw [sum_range_succ, mul_add, IH]
    ring