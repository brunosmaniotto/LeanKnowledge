import Mathlib

theorem union_idempotent (S : Set α) : S ∪ S = S := by
  ext x
  simp [Set.mem_union]