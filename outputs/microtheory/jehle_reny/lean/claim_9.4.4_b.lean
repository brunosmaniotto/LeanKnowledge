import Mathlib

open Finset BigOperators
open BigOperators

/-- Claim 9.4.4(b): In the optimal selling mechanism, revenue is maximized by allocating
    to the bidder with highest positive marginal revenue MR_i(v_i) = v_i − (1−F_i(v_i))/f_i(v_i).
    Part 1: Shifting probability ε from a lower-MR bidder to a higher-MR bidder
    strictly increases expected revenue (by ε·(MR_i − MR_j) > 0).
    Part 2: If all marginal revenues are negative, zero allocation (seller keeps)
    yields weakly higher revenue than any non-negative allocation. -/
theorem Claim_9_4_4_b {I : Type*} [Fintype I] [DecidableEq I]
    (MR : I → ℝ) :
    -- Part 1: Revenue gain from shifting probability ε from bidder j to bidder i
    (∀ (y_i y_j R MR_i MR_j ε : ℝ), MR_i > MR_j → ε > 0 →
      R + y_i * MR_i + y_j * MR_j < R + (y_i + ε) * MR_i + (y_j - ε) * MR_j) ∧
    -- Part 2: All-negative MR ⟹ seller keeps (zero allocation is optimal)
    ((∀ i, MR i < 0) → ∀ (y : I → ℝ), (∀ i, 0 ≤ y i) →
      ∑ i : I, y i * MR i ≤ 0) := by
  constructor
  · intro y_i y_j R MR_i MR_j ε hMR hε
    nlinarith
  · intro hMR_neg y hy_nonneg
    apply Finset.sum_nonpos
    intro i _
    exact mul_nonpos_of_nonneg_of_nonpos (hy_nonneg i) (hMR_neg i).le