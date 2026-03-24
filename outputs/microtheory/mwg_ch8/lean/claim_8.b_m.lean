import Mathlib
open BigOperators
open Topology

theorem undominated_strategies_two_step_elimination
    {S : Type*} [Fintype S] [DecidableEq S]
    (dominated : S → Prop) [DecidablePred dominated]
    (w : S → ℝ)
    (hw_nonneg : ∀ s, 0 ≤ w s)
    (hw_sum : ∑ s : S, w s = 1)
    (support_cond : ∀ s, dominated s → w s = 0) :
    ∑ s ∈ Finset.univ.filter (fun s => ¬ dominated s), w s = 1 := by
  have h : ∑ s : S, w s = ∑ s ∈ Finset.univ.filter (fun s => ¬ dominated s), w s := by
    symm
    apply Finset.sum_subset (Finset.filter_subset _ _)
    intro s _ hs
    simp [Finset.mem_filter] at hs
    exact support_cond s (by tauto)
  linarith