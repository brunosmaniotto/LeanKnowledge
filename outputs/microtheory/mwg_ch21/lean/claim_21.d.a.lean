import Mathlib

section PreferenceRelations

variable {α : Type*} [Fintype α] [DecidableEq α]

def StrictPart (R : α → α → Prop) (x y : α) : Prop := R x y ∧ ¬R y x