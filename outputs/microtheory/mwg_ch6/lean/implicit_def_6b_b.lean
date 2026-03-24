import Mathlib

open BigOperators Finset
open Topology

/-- A simple lottery over `N` outcomes: a probability distribution
    with non-negative reals summing to 1. -/
structure SimpleLottery (N : ℕ) where
  prob : Fin N → ℝ
  prob_nonneg : ∀ n, 0 ≤ prob n
  prob_sum : ∑ n : Fin N, prob n = 1

/-- The reduced lottery of a compound lottery `(L_1, …, L_K; α_1, …, α_K)`.
    The probability of outcome `n` in the reduced lottery is
    `p_n = ∑ k, α k * (L k).prob n`.
    Equivalently, `L = α_1 L_1 + ⋯ + α_K L_K`. -/
noncomputable def reducedLottery {N K : ℕ}
    (L : Fin K → SimpleLottery N)
    (α : Fin K → ℝ)
    (hα_nonneg : ∀ k, 0 ≤ α k)
    (hα_sum : ∑ k : Fin K, α k = 1) :
    SimpleLottery N where
  prob n := ∑ k : Fin K, α k * (L k).prob n
  prob_nonneg n := sum_nonneg fun k _ => mul_nonneg (hα_nonneg k) ((L k).prob_nonneg n)
  prob_sum := by
    calc ∑ n : Fin N, ∑ k : Fin K, α k * (L k).prob n
        = ∑ k : Fin K, ∑ n : Fin N, α k * (L k).prob n := sum_comm
      _ = ∑ k : Fin K, α k * ∑ n : Fin N, (L k).prob n := by
          congr 1; ext k; rw [mul_sum]
      _ = 1 := by
          have h : ∀ k : Fin K, ∑ n : Fin N, (L k).prob n = 1 := fun k => (L k).prob_sum
          simp_rw [h, mul_one, hα_sum]