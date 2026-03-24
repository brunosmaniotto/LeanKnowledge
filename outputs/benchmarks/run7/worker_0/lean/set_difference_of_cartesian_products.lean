import Mathlib

open Set

theorem set_diff_prod {α β : Type*} (S₁ T₁ : Set α) (S₂ T₂ : Set β) :
    (S₁ ×ˢ S₂) \ (T₁ ×ˢ T₂) = (S₁ ×ˢ (S₂ \ T₂)) ∪ ((S₁ \ T₁) ×ˢ S₂) := by
  ext ⟨x, y⟩
  constructor
  · intro h
    rcases h with ⟨hxy, hxy'⟩
    rcases mem_prod.1 hxy with ⟨hx, hy⟩
    by_cases hxT : x ∈ T₁
    · have hyT : y ∉ T₂ := by
        intro hyT'
        apply hxy'
        exact mem_prod.mpr ⟨hxT, hyT'⟩
      left
      exact mem_prod.mpr ⟨hx, ⟨hy, hyT⟩⟩
    · right
      exact mem_prod.mpr ⟨⟨hx, hxT⟩, hy⟩
  · intro h
    rcases h with (h | h)
    · rcases mem_prod.1 h with ⟨hx, hy⟩
      rcases hy with ⟨hy, hyT⟩
      constructor
      · exact mem_prod.mpr ⟨hx, hy⟩
      · intro h'
        rcases mem_prod.1 h' with ⟨hxT', hyT'⟩
        exact hyT hyT'
    · rcases mem_prod.1 h with ⟨hx, hy⟩
      rcases hx with ⟨hx, hxT⟩
      constructor
      · exact mem_prod.mpr ⟨hx, hy⟩
      · intro h'
        rcases mem_prod.1 h' with ⟨hxT', hyT'⟩
        exact hxT hxT'