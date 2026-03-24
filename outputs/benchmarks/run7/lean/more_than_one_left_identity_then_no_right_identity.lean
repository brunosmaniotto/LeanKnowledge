import Mathlib

variable {S : Type} [Mul S]

def LeftIdentity (e : S) : Prop := ∀ x, e * x = x