import Mathlib

def composite_of_order_isomorphisms_is_order_isomorphism {α β γ : Type _} [LE α] [LE β] [LE γ]
    (φ : α ≃o β) (ψ : β ≃o γ) : α ≃o γ :=
  φ.trans ψ