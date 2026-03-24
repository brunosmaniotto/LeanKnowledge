import Mathlib

theorem Intersection_of_Symmetric_Relations_is_Symmetric {α : Type} {r₁ r₂ : α → α → Prop}
    (h₁ : Symmetric r₁) (h₂ : Symmetric r₂) : Symmetric (λ x y => r₁ x y ∧ r₂ x y) := by
  intro x y h
  exact ⟨h₁ h.1, h₂ h.2⟩