import Mathlib

open Subgroup

variable {G : Type*} [Group G]

theorem existence_of_unique_subgroup_generated_by (S : Set G) :
    ∃! H : Subgroup G, S ⊆ H ∧ (∀ K : Subgroup G, S ⊆ K → H ≤ K) ∧ H = sInf {K : Subgroup G | S ⊆ K} := by
  set H := closure S with hH_def
  have h_contains : S ⊆ H := subset_closure
  have h_smallest : ∀ K : Subgroup G, S ⊆ K → H ≤ K := by
    intro K hK
    exact (closure_le (k := S) (K := K)).2 hK
  have h_inf : H = sInf {K : Subgroup G | S ⊆ K} := rfl
  refine ⟨H, ⟨h_contains, h_smallest, h_inf⟩, ?_⟩
  intro H' ⟨hS', hH', hInf'⟩
  apply le_antisymm
  · exact hH' H h_contains
  · exact h_smallest H' hS'