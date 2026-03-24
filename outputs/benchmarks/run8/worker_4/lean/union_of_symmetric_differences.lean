import Mathlib

open Set
open scoped symmDiff

variable {α : Type _} (R S T : Set α)

theorem union_symmDiff_eq_union_minus_inter : (R ∆ S) ∪ (S ∆ T) = (R ∪ S ∪ T) \ (R ∩ S ∩ T) := by
  ext x
  simp only [mem_union, mem_symmDiff, mem_inter_iff, mem_diff]
  by_cases hR : x ∈ R <;> by_cases hS : x ∈ S <;> by_cases hT : x ∈ T <;> simp [hR, hS, hT]