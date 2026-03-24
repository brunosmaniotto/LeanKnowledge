import Mathlib

variable {α : Type*} (R : α → α → Prop)

def LeftEuclidean : Prop := ∀ x y z, R x z → R y z → R x y