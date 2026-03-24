import Mathlib

variable {α : Type _}

/-- The identity mapping on a set S. -/
def identityOn (S : Set α) : S → S := fun x => x