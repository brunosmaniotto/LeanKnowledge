import Mathlib
open scoped symmDiff

theorem union_eq_symmDiff_symmDiff_inter {α : Type _} (A B : Set α) : A ∪ B = (A ∆ B) ∆ (A ∩ B) := by
  ext x
  simp only [Set.mem_union, Set.mem_inter_iff, Set.mem_symmDiff, Set.mem_diff]
  tauto