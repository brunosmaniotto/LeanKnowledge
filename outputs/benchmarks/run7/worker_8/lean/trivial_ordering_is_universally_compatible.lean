import Mathlib

open Set

variable {α : Type _}

/-- The trivial ordering on a set S is the diagonal relation (equality). -/
def trivialOrdering (S : Set α) : Subtype S → Subtype S → Prop := fun a b => a = b