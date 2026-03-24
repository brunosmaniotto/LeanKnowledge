import Mathlib
open Finset
open BigOperators

theorem closed_form_triangular (n : ℕ) : ∑ i ∈ range n, (i + 1) = n * (n + 1) / 2 := by
  have H : 2 * (∑ i ∈ range n, (i + 1)) = n * (n + 1) := by
    induction' n with k IH
    · simp
    · rw [sum_range_succ, mul_add, IH]
      ring
  calc
    ∑ i ∈ range n, (i + 1) = (2 * (∑ i ∈ range n, (i + 1))) / 2 := by
      rw [Nat.mul_div_cancel_left _ (by norm_num)]
    _ = n * (n + 1) / 2 := by rw [H]