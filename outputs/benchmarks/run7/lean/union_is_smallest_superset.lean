import Mathlib

open Set

variable {α : Type*}

theorem union_is_smallest_superset (S₁ S₂ T : Set α) : (S₁ ⊆ T ∧ S₂ ⊆ T) ↔ (S₁ ∪ S₂) ⊆ T :=
  Set.union_subset_iff.symm