import Mathlib

open Set

theorem set_and_relative_complement_form_partition (α : Type*) (U S : Set α) 
    (h_subset : S ⊆ U) (h_nonempty : S ≠ ∅) (h_proper : S ≠ U) : 
    S ∪ (U \ S) = U ∧ S ∩ (U \ S) = ∅ := by
  constructor
  · exact Set.union_diff_cancel h_subset
  · exact Set.inter_diff_self S U