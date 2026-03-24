import Mathlib

theorem injection_of_composite_injection {α β γ : Type _} (f : α → β) (g : β → γ)
    (h : Function.Injective (g ∘ f)) : Function.Injective f := by
  intro a b hf
  apply h
  calc
    (g ∘ f) a = g (f a) := rfl
    _ = g (f b) := by rw [hf]
    _ = (g ∘ f) b := rfl