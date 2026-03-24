import Mathlib

def choiceStar {α : Type*} (B : Set α) (R : α → α → Prop) : Set α :=
  { x ∈ B | ∀ y ∈ B, R x y }