import Mathlib

theorem intersection_is_largest_subset {α : Type*} (S T1 T2 : Set α) :
    (S ⊆ T1 ∧ S ⊆ T2) ↔ S ⊆ (T1 ∩ T2) :=
  Set.subset_inter_iff.symm