import Mathlib

open Finset
open BigOperators

theorem triangular_formula (n : ℕ) : (∑ i ∈ range (n + 1), i) = n * (n + 1) / 2 := by
  rw [sum_range_id, Nat.add_sub_cancel, Nat.mul_comm]