import Mathlib

universe u v

theorem Function.injective_iff_left_cancellable {Y : Type u} {Z : Type v} (f : Y → Z) :
    Function.Injective f ↔ ∀ (X : Type u) (g₁ g₂ : X → Y), f ∘ g₁ = f ∘ g₂ → g₁ = g₂ := by
  constructor
  · intro h_inj X g₁ g₂ h
    ext x
    apply h_inj
    exact congr_fun h x
  · intro h_cancel y₁ y₂ h
    let g₁ : Y → Y := fun _ => y₁
    let g₂ : Y → Y := fun _ => y₂
    have h_comp : f ∘ g₁ = f ∘ g₂ := by
      ext y
      simp [g₁, g₂, h]
    have h_g : g₁ = g₂ := h_cancel Y g₁ g₂ h_comp
    have : g₁ y₁ = g₂ y₁ := by rw [h_g]
    simp [g₁, g₂] at this
    exact this