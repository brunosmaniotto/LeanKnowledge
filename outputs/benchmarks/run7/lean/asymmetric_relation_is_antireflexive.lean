import Mathlib

def Antireflexive {α : Type} (r : α → α → Prop) : Prop := ∀ x, ¬ r x x