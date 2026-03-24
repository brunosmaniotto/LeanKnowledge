import Mathlib

open Set

theorem set_union_empty (S : Set α) : S ∪ ∅ = S := by
  ext x
  simp