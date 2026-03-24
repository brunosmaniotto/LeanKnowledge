import Mathlib

theorem image_inter_subset_inter_image {S T : Type*} (R : S → T → Prop) (S₁ S₂ : Set S) :
    { y | ∃ x ∈ S₁ ∩ S₂, R x y } ⊆ { y | ∃ x ∈ S₁, R x y } ∩ { y | ∃ x ∈ S₂, R x y } := by
  intro y hy
  rcases hy with ⟨x, ⟨hxS1, hxS2⟩, hR⟩
  constructor
  · exact ⟨x, hxS1, hR⟩
  · exact ⟨x, hxS2, hR⟩