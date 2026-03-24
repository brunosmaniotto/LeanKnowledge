import Mathlib
open Finset
open BigOperators

theorem sum_range_formula (n : ℕ) :
    ∑ j ∈ range n, (1 : ℚ) / (((j : ℚ) + 1) * ((j : ℚ) + 2)) = (n : ℚ) / (n + 1) := by
  induction' n with k IH
  · simp
  · rw [sum_range_succ, IH]
    push_cast
    field_simp
    ring