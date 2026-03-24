import Mathlib

open Finset BigOperators
open BigOperators

theorem bayes_rule_consistency
    (H : Finset ι)
    (hH : H.Nonempty)
    (prob : ι → ℝ)
    (hpos : ∀ x ∈ H, 0 < prob x)
    : (∀ x ∈ H, 0 < prob x / ∑ x' ∈ H, prob x') ∧
      (∑ x ∈ H, prob x / ∑ x' ∈ H, prob x') = 1 := by
  have hsum_pos : 0 < ∑ x' ∈ H, prob x' := by
    exact Finset.sum_pos hpos hH
  constructor
  · intro x hx
    apply div_pos (hpos x hx) hsum_pos
  · rw [← Finset.sum_div]
    exact div_self (ne_of_gt hsum_pos)