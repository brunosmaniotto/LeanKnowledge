import Mathlib

namespace Nat

lemma max_eq_add_sub (n m : ℕ) : max n m = (n - m) + m := by
  by_cases h : n ≤ m
  · rw [max_eq_right h]
    rw [Nat.sub_eq_zero_of_le h, zero_add]
  · have h' : m ≤ n := by omega
    rw [max_eq_left h']
    rw [Nat.sub_add_cancel h']

open Primrec