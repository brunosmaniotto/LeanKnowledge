import Mathlib

open Matrix

variable {R n : Type} [CommRing R] [Fintype n] [DecidableEq n]

/-- Two matrices are equivalent if there exist invertible matrices P and Q such that B = Q⁻¹ * A * P. -/
def MatrixEquivalence (A B : Matrix n n R) : Prop :=
  ∃ (P Q : Matrix n n R) (hP : IsUnit P) (hQ : IsUnit Q), B = Q⁻¹ * A * P