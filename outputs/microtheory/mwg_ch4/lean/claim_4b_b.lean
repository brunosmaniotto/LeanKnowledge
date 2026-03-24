import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem Claim_4B_b
    {I : ℕ} (hI : 0 < I) (c : Fin I → ℝ) :
    (∀ dw : Fin I → ℝ, ∑ i, dw i = 0 → ∑ i, c i * dw i = 0) ↔
    (∀ i j : Fin I, c i = c j) := by
  constructor
  · intro h i j
    by_cases hij : i = j
    · rw [hij]
    · have decomp : ∀ k : Fin I,
        (if k = i then (1 : ℝ) else if k = j then -1 else 0) =
        (if k = i then (1 : ℝ) else 0) + (if k = j then (-1 : ℝ) else 0) := by
        intro k; split_ifs <;> simp_all
      have decomp2 : ∀ k : Fin I,
        c k * (if k = i then (1 : ℝ) else if k = j then -1 else 0) =
        (if k = i then c k else 0) + (if k = j then -c k else 0) := by
        intro k; split_ifs <;> simp_all <;> ring
      have sum_zero : ∑ k : Fin I, (if k = i then (1 : ℝ) else if k = j then -1 else 0) = 0 := by
        simp_rw [decomp, sum_add_distrib, sum_ite_eq', mem_univ, if_true]; ring
      have key := h _ sum_zero
      simp_rw [decomp2, sum_add_distrib, sum_ite_eq', mem_univ, if_true] at key
      linarith
  · intro heq dw hsum
    calc ∑ k, c k * dw k
        = ∑ k, c ⟨0, hI⟩ * dw k := by congr 1; ext k; rw [heq]
      _ = c ⟨0, hI⟩ * ∑ k, dw k := by rw [← mul_sum]
      _ = 0 := by rw [hsum, mul_zero]