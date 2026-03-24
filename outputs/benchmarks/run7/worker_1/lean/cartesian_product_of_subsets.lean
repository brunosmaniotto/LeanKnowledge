import Mathlib

variable {α β : Type _} {A B : Set α} {S T : Set β}

theorem Set.prod_subset_prod (hA : A ⊆ B) (hS : S ⊆ T) : A ×ˢ S ⊆ B ×ˢ T := by
  rintro ⟨x, y⟩ ⟨hx, hy⟩
  exact ⟨hA hx, hS hy⟩