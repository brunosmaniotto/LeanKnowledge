import Mathlib

variable {G : Type} [Group G]

def conjSet (a : G) (S : Set G) : Set G :=
  { y | ∃ x ∈ S, y = a * x * a⁻¹ }