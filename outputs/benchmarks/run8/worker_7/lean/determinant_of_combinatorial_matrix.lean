import Mathlib

open Matrix
open BigOperators

variable {R : Type u} [CommRing R]

def combinatorialMatrix (n : ℕ) (x y : R) : Matrix (Fin n) (Fin n) R :=
  fun i j => if i = j then x + y else y