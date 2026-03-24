import Mathlib

variable {S : Type*}

/-- Restriction of a binary operation to a subset `T` as a function `T → T → S`. -/
def restrict (op : S → S → S) (T : Set S) : T → T → S :=
  fun a b => op a b