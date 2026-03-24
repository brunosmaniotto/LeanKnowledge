import Mathlib

variable {α : Type*}

/-- The inverse of a set of pairs, obtained by swapping each pair. -/
def inv (s : Set (α × α)) : Set (α × α) := {p | (p.2, p.1) ∈ s}