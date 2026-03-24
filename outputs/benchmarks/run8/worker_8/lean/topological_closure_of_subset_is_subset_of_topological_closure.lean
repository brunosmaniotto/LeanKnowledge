import Mathlib

theorem closure_subset_closure_of_subset {S : Type*} [TopologicalSpace S] {H K : Set S} 
    (hHK : H ⊆ K) : closure H ⊆ closure K :=
  closure_mono hHK