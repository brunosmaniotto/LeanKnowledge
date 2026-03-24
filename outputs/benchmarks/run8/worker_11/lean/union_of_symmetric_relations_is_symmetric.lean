import Mathlib

theorem symmetric_union {α : Type u} {r₁ r₂ : α → α → Prop} (h₁ : Symmetric r₁) (h₂ : Symmetric r₂) :
    Symmetric (fun x y => r₁ x y ∨ r₂ x y) := by
  intro x y h
  rcases h with (h | h)
  · left
    exact h₁ h
  · right
    exact h₂ h