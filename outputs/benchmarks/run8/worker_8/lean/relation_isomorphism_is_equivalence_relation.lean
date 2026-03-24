import Mathlib

universe u v w

theorem reflexive {α : Type u} (r : α → α → Prop) : Nonempty (r ≃r r) :=
  ⟨RelIso.refl r⟩