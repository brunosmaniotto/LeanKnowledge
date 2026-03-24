import Mathlib

theorem reflexive_inter {α : Type _} {r₁ r₂ : α → α → Prop}
    (h₁ : Reflexive r₁) (h₂ : Reflexive r₂) : Reflexive (λ a b => r₁ a b ∧ r₂ a b) := by
  intro a
  exact ⟨h₁ a, h₂ a⟩