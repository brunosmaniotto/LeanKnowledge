import Mathlib

open Ideal

/-- The quotient ring of a commutative ring by an ideal is commutative. -/
theorem quotient_ring_mul_comm [CommRing R] (I : Ideal R) (a b : R ⧸ I) : a * b = b * a :=
  Quotient.inductionOn₂ a b fun x y => by simp [mul_comm]