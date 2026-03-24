import Mathlib

open Set

variable {S T : Type*}

theorem image_diff_subset (r : Set (S × T)) (A B : Set S) :
    { y | ∃ x ∈ A, (x, y) ∈ r } \ { y | ∃ x ∈ B, (x, y) ∈ r } ⊆ { y | ∃ x ∈ A \ B, (x, y) ∈ r } := by
  intro y hy
  rcases hy with ⟨hy_left, hy_right⟩
  rcases hy_left with ⟨x, hxA, hxy⟩
  have hx_not_mem : x ∉ B := by
    intro hxB
    apply hy_right
    exact ⟨x, hxB, hxy⟩
  exact ⟨x, ⟨hxA, hx_not_mem⟩, hxy⟩