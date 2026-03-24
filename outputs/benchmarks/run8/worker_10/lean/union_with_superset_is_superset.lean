import Mathlib.Data.Set.Basic

theorem subset_iff_union_eq {α : Type} {S T : Set α} : S ⊆ T ↔ S ∪ T = T :=
  Set.union_eq_right.symm