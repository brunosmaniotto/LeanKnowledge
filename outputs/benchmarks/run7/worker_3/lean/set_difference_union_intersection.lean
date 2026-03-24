import Mathlib

open Set

theorem set_diff_union_inter (S T : Set α) : S = (S \ T) ∪ (S ∩ T) := by
  ext x
  constructor
  · intro hx
    by_cases h : x ∈ T
    · exact Or.inr ⟨hx, h⟩
    · exact Or.inl ⟨hx, h⟩
  · intro h
    rcases h with (⟨hx, _⟩ | ⟨hx, _⟩)
    · exact hx
    · exact hx