import Mathlib

theorem ordinal_property_monotone {α : Type*} [Preorder α] {β : Type*} [Preorder β]
    {γ : Type*} [Preorder γ]
    (u : α → β) (f : β → γ) (hu : Monotone u) (hf : Monotone f) :
    Monotone (f ∘ u) :=
  hf.comp hu