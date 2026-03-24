import Mathlib

theorem union_inter_subset_union {α : Type} (S₁ S₂ T₁ T₂ : Set α) :
    (S₁ ∩ S₂) ∪ (T₁ ∩ T₂) ⊆ S₁ ∪ T₁ := by
  intro x hx
  rcases hx with (⟨hxS₁, hxS₂⟩ | ⟨hxT₁, hxT₂⟩)
  · exact Or.inl hxS₁
  · exact Or.inr hxT₁