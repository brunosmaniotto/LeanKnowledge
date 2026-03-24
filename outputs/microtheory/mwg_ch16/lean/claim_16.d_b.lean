import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- When each term is at least as large as its target, but the total sum equals
the total of targets, each term must equal its target. This captures the
key step in proving p·x*_i = w_i for all i in a Walrasian equilibrium
with locally nonsatiated preferences. -/
theorem walrasian_budget_equality
    {I : Type*} [DecidableEq I] [Fintype I]
    (px w : I → ℝ)
    (h_ge : ∀ i, px i ≥ w i)
    (h_sum : ∑ i, px i = ∑ i, w i) :
    ∀ i, px i = w i := by
  by_contra h
  push_neg at h
  obtain ⟨j, hj⟩ := h
  have hj_gt : px j > w j := lt_of_le_of_ne (h_ge j) (Ne.symm hj)
  have : ∑ i, px i > ∑ i, w i := by
    exact Finset.sum_lt_sum (fun i _ => h_ge i) ⟨j, Finset.mem_univ j, hj_gt⟩
  linarith