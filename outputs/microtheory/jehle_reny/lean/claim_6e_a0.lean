import Mathlib

open Finset BigOperators
open Topology
open BigOperators

/-- Under a utilitarian SWF W(u) = Σᵢ uᵢ, social states are ranked by the sum of
    individual utility differences: W(u(x)) ≥ W(u(y)) ↔ Σᵢ (uᵢ(x) - uᵢ(y)) ≥ 0.
    This shows that utility-difference comparability across individuals is the
    determining factor in utilitarian social ranking. -/
theorem utilitarian_ranking_by_utility_differences
    {I : Type*} [Fintype I] [DecidableEq I]
    (u_x u_y : I → ℝ) :
    (∑ i : I, u_x i) ≥ (∑ i : I, u_y i) ↔
    (∑ i : I, (u_x i - u_y i)) ≥ 0 := by
  constructor
  · intro h
    have : ∑ i : I, (u_x i - u_y i) = ∑ i : I, u_x i - ∑ i : I, u_y i := by
      rw [Finset.sum_sub_distrib]
    linarith
  · intro h
    have : ∑ i : I, (u_x i - u_y i) = ∑ i : I, u_x i - ∑ i : I, u_y i := by
      rw [Finset.sum_sub_distrib]
    linarith