import Mathlib

variable {α : Type*} (r : α → α → Prop)

def Asymmetric (r : α → α → Prop) : Prop := ∀ ⦃x y⦄, r x y → ¬ r y x