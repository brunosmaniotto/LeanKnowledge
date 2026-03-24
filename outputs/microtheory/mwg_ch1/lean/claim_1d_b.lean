import Mathlib

variable {α : Type*}

def ChoiceStar (R : α → α → Prop) (B : Set α) : Set α :=
  {x ∈ B | ∀ y ∈ B, R x y}