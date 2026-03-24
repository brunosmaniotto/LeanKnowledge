import Mathlib

open Finset
open BigOperators

theorem sum_telescope (b : ℕ → ℝ) (n : ℕ) :
    ∑ k ∈ Icc 1 n, (b k - b (k + 1)) = b 1 - b (n + 1) := by
  induction' n with m IH
  · simp
  · have h : 1 ≤ m + 1 := by omega
    rw [sum_Icc_succ_top h, IH]
    ring