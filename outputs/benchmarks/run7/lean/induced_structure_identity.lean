import Mathlib

variable (S T : Type) [MulOneClass T]

/-- The constant function mapping every element of `S` to the identity of `T`. -/
def f_e : S → T := fun _ ↦ 1