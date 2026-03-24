import Mathlib

open Set
open scoped symmDiff

theorem symmetricDifference_iUnion_subset {ι α : Type*} (S T : ι → Set α) :
    (⋃ i, S i) ∆ (⋃ i, T i) ⊆ ⋃ i, S i ∆ T i := by
  intro x hx
  rcases mem_symmDiff.1 hx with (⟨hx_left, hx_right⟩ | ⟨hx_left, hx_right⟩)
  · rcases mem_iUnion.1 hx_left with ⟨i, hi⟩
    have hx_right' : x ∉ ⋃ i, T i := hx_right
    have hx_right_i : x ∉ T i := by
      intro h
      exact hx_right' (mem_iUnion.2 ⟨i, h⟩)
    exact mem_iUnion.2 ⟨i, mem_symmDiff.2 (Or.inl ⟨hi, hx_right_i⟩)⟩
  · rcases mem_iUnion.1 hx_left with ⟨i, hi⟩
    have hx_right' : x ∉ ⋃ i, S i := hx_right
    have hx_right_i : x ∉ S i := by
      intro h
      exact hx_right' (mem_iUnion.2 ⟨i, h⟩)
    exact mem_iUnion.2 ⟨i, mem_symmDiff.2 (Or.inr ⟨hi, hx_right_i⟩)⟩