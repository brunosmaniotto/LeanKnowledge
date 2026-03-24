import Mathlib

open Set

variable {R : Type} [Ring R]

def IsTwoSided (I : Ideal R) : Prop :=
  ∀ (r : R) (j : R), j ∈ I → j * r ∈ I