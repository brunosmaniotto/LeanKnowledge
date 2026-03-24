import Mathlib

open Set

theorem symmDiff_union_eq_diff {α : Type*} (R S T : Set α) : 
  symmDiff (R ∪ T) (S ∪ T) = (symmDiff R S) \ T := by
  ext x
  simp only [mem_symmDiff, mem_diff, mem_union, not_or]
  tauto