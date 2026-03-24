import Mathlib

variable {R : Type*} [CommRing R]

-- Define division of ring element by unit
def div_unit (a : R) (u : Rˣ) : R := a * ↑u⁻¹