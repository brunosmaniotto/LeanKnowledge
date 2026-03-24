import Mathlib.Data.Set.Prod

open Set

variable {α β : Type*}

theorem cartesian_product_distrib_union_right (A : Set α) (B C : Set β) :
    A ×ˢ (B ∪ C) = (A ×ˢ B) ∪ (A ×ˢ C) := by
  ext ⟨x, y⟩
  simp only [mem_prod, mem_union]
  constructor
  · rintro ⟨hx, hy | hy⟩
    · exact Or.inl ⟨hx, hy⟩
    · exact Or.inr ⟨hx, hy⟩
  · rintro (⟨hx, hy⟩ | ⟨hx, hy⟩)
    · exact ⟨hx, Or.inl hy⟩
    · exact ⟨hx, Or.inr hy⟩