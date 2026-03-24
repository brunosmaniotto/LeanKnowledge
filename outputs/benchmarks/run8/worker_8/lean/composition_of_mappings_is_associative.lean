import Mathlib

theorem composition_assoc {α β γ δ : Type*} (f₁ : α → β) (f₂ : β → γ) (f₃ : γ → δ) :
    (f₃ ∘ f₂) ∘ f₁ = f₃ ∘ (f₂ ∘ f₁) := by
  ext x
  simp