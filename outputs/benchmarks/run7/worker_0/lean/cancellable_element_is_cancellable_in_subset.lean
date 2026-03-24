import Mathlib

variable {M : Type*} [Mul M]

def IsLeftCancellativeElem (x : M) : Prop := ∀ a b : M, x * a = x * b → a = b