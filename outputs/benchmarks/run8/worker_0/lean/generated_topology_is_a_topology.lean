import Mathlib

open TopologicalSpace

theorem Generated_Topology_is_a_Topology (X : Type) (S : Set (Set X)) :
    ∃ τ : TopologicalSpace X, ∀ s ∈ S, τ.IsOpen s := by
  refine ⟨generateFrom S, ?_⟩
  intro s hs
  exact GenerateOpen.basic s hs