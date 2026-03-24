import Mathlib

open Finset BigOperators Matrix
open Topology
open BigOperators

theorem Claim_5AA_c {L : ℕ} (A : Matrix (Fin L) (Fin L) ℝ) (n : ℕ) :
    (1 - A) * (∑ k ∈ Finset.range n, A ^ k) = 1 - A ^ n := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    rw [pow_succ']
    noncomm_ring