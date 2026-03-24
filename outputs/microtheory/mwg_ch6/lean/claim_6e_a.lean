import Mathlib

open Finset BigOperators
open Topology
open BigOperators

theorem claim_6E_a {S : Type*} [Fintype S] [DecidableEq S]
    (π : S → ℝ)
    (hπ_nonneg : ∀ s, 0 ≤ π s)
    (hπ_sum : ∑ s : S, π s = 1)
    (g : S → ℝ) :
    ∀ x : ℝ,
      let F := fun x => ∑ s ∈ Finset.univ.filter (fun s => g s ≤ x), π s
      0 ≤ F x ∧ F x ≤ 1 := by
  intro x
  simp only
  constructor
  · apply Finset.sum_nonneg
    intro s _
    exact hπ_nonneg s
  · have h : ∑ s ∈ Finset.univ.filter (fun s => g s ≤ x), π s
        ≤ ∑ s : S, π s := by
      apply Finset.sum_le_univ_sum_of_nonneg
      exact hπ_nonneg
    linarith