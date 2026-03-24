import Mathlib

open Set

variable {α : Type*} (S T : Set α)

theorem cartesian_product_anticommutative (hS : S.Nonempty) (hT : T.Nonempty) (hST : S ×ˢ T = T ×ˢ S) : S = T := by
  apply Set.Subset.antisymm
  · intro x hx
    rcases hT with ⟨y, hy⟩
    have h : (x, y) ∈ S ×ˢ T := by
      rw [mem_prod]
      exact ⟨hx, hy⟩
    rw [hST] at h
    rw [mem_prod] at h
    exact h.1
  · intro x hx
    rcases hS with ⟨y, hy⟩
    have h : (x, y) ∈ T ×ˢ S := by
      rw [mem_prod]
      exact ⟨hx, hy⟩
    rw [← hST] at h
    rw [mem_prod] at h
    exact h.1