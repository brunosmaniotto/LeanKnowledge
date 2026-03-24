import Mathlib

variable {S : Type}

def Asymmetric (r : Set (S × S)) : Prop := ∀ ⦃x y⦄, (x, y) ∈ r → (y, x) ∉ r