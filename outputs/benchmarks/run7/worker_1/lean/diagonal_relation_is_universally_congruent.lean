import Mathlib

-- The diagonal relation on a type S is just equality.
def diagonal_relation (S : Type) : S → S → Prop := Eq