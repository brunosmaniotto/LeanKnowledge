import Mathlib

variable {G H : Type*} [Group G] [Group H]

theorem prod_comm_iff :
    (∀ p q : G × H, p * q = q * p) ↔ (∀ g₁ g₂ : G, g₁ * g₂ = g₂ * g₁) ∧ (∀ h₁ h₂ : H, h₁ * h₂ = h₂ * h₁) := by
  constructor
  · intro h
    constructor
    · intro g₁ g₂
      have h1 : (g₁, (1 : H)) * (g₂, 1) = (g₂, 1) * (g₁, 1) := h (g₁, 1) (g₂, 1)
      simp at h1
      exact h1
    · intro h₁ h₂
      have h1 : ((1 : G), h₁) * (1, h₂) = (1, h₂) * (1, h₁) := h (1, h₁) (1, h₂)
      simp at h1
      exact h1
  · intro ⟨hG, hH⟩ p q
    ext <;> simp [hG, hH]