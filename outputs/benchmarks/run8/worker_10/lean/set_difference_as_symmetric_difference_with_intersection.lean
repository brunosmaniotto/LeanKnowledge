import Mathlib

open Set
open scoped symmDiff

theorem set_diff_eq_symmDiff_inter {α : Type*} (S T : Set α) : S \ T = S ∆ (S ∩ T) := by
  ext x
  simp only [mem_symmDiff, mem_diff, mem_inter_iff]
  by_cases h : x ∈ T
  · simp [h]
  · simp [h]