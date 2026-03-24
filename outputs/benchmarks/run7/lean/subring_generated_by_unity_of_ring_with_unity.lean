import Mathlib
open Subring Ideal

variable {R : Type _} [Ring R]

/-- The canonical homomorphism from ℤ to R. -/
def g : ℤ →+* R := Int.castRingHom R