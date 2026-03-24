import Mathlib

/-- A relation is serial if every element is related to at least one element. -/
def Serial {α : Type} (r : α → α → Prop) : Prop := ∀ x, ∃ y, r x y