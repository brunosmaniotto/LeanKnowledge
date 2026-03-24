import Mathlib

open Set
open scoped symmDiff

theorem Power_Set_is_Closed_under_Symmetric_Difference {α : Type*} (S : Set α) :
    ∀ A B, A ∈ 𝒫 S → B ∈ 𝒫 S → A ∆ B ∈ 𝒫 S := by
  intro A B hA hB
  rw [mem_powerset_iff] at hA hB
  intro x hx
  rw [mem_symmDiff] at hx
  rcases hx with (⟨hxA, _⟩ | ⟨hxB, _⟩)
  · exact hA hxA
  · exact hB hxB