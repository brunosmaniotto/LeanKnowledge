import Mathlib

theorem odd_sum_eq_square (n : ℕ) : (∑ j ∈ Finset.range n, (2 * j + 1)) = n ^ 2 := by
  induction' n with k IH
  · simp
  · rw [Finset.sum_range_succ, IH]
    ring