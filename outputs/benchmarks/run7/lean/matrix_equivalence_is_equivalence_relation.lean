import Mathlib

open Matrix

variable {R : Type*} [CommRing R] {m n : Type*} [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]

/-- Matrix equivalence relation: A is equivalent to B if there exist invertible matrices
    Q and P such that A = Q * B * P. -/
def Matrix.Equivalent (A B : Matrix m n R) : Prop :=
  ∃ (P : Matrix n n R) (Q : Matrix m m R), IsUnit P ∧ IsUnit Q ∧ A = Q * B * P