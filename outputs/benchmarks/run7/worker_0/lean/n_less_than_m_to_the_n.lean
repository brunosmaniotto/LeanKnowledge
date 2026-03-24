import Mathlib

open Nat

theorem N_less_than_M_to_the_N (m n : ℕ) (hm : 1 < m) (hn : 0 < n) : n < m ^ n := by
  have hn1 : 1 ≤ n := by omega
  have h2 : 2 ≤ m := by omega
  refine Nat.le_induction (by rwa [pow_one]) (fun k hk1 hk => ?_) n hn1
  have h_mul_le : k + 1 ≤ m * k := by
    have : 1 ≤ k := hk1
    calc
      k + 1 ≤ 2 * k := by omega
      _ ≤ m * k := Nat.mul_le_mul_right k h2
  have h_mul_lt : m * k < m * m ^ k :=
    Nat.mul_lt_mul_of_pos_left hk (by omega : 0 < m)
  calc
    k + 1 ≤ m * k := h_mul_le
    _ < m * m ^ k := h_mul_lt
    _ = m ^ k * m := by rw [mul_comm]
    _ = m ^ (k + 1) := by rw [pow_succ]