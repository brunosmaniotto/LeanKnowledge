import Mathlib

variable {n : Type*} [Fintype n] [DecidableEq n] {R : Type*} [CommRing R]

namespace Matrix

/-- Two square matrices A and B are similar if there exists an invertible matrix P such that
    P⁻¹ * A * P = B. -/
def IsSimilar (A B : Matrix n n R) : Prop :=
  ∃ (P : Matrix n n R), IsUnit P ∧ P⁻¹ * A * P = B