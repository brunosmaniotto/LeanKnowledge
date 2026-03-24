import Mathlib

open Set Bornology

theorem Finite_Union_of_Bounded_Subsets {α ι : Type*} [MetricSpace α] (t : Finset ι) (s : ι → Set α)
    (h : ∀ i ∈ t, IsBounded (s i)) : IsBounded (⋃ i ∈ t, s i) := by
  rw [isBounded_biUnion_finset]
  exact h