import Mathlib

open Matrix

variable {R : Type} [CommRing R]

namespace CombinatorialMatrix

def J (n : ℕ) : Matrix (Fin n) (Fin n) R := fun i j => 1