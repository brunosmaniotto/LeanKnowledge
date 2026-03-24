import Mathlib

theorem set_union_comm (S T : Set α) : S ∪ T = T ∪ S := by
  ext x
  simp [Set.mem_union, or_comm]