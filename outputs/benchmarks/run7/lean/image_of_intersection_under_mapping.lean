import Mathlib

open Set

theorem image_inter_subset {S T : Type*} (f : S → T) (S₁ S₂ : Set S) :
    f '' (S₁ ∩ S₂) ⊆ f '' S₁ ∩ f '' S₂ := by
  intro y hy
  rcases hy with ⟨x, ⟨hx₁, hx₂⟩, rfl⟩
  exact ⟨⟨x, hx₁, rfl⟩, ⟨x, hx₂, rfl⟩⟩