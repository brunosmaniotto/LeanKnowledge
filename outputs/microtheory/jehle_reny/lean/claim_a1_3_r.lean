import Mathlib

open Finset
open Topology
open BigOperators

theorem claim_A1_3_r {n : ℕ} {x f : Fin n → ℝ}
    (hx_sum : ∑ i, x i = 1)
    (hf_sum : ∑ i, f i = 1)
    (hne : x ≠ f) :
    ∃ i, x i > f i := by
  by_contra h
  push_neg at h
  have heq : x = f := by
    ext i
    have hle := h i
    have hsum_le : ∑ i, x i ≤ ∑ i, f i := Finset.sum_le_sum (fun i _ => h i)
    rw [hx_sum, hf_sum] at hsum_le
    have hsum_eq : ∑ i, x i = ∑ i, f i := by linarith
    exact le_antisymm hle (by
      by_contra h'
      push_neg at h'
      have : ∑ i, x i < ∑ i, f i := by
        exact Finset.sum_lt_sum (fun j _ => h j) ⟨i, Finset.mem_univ i, h'⟩
      linarith)
  exact hne heq