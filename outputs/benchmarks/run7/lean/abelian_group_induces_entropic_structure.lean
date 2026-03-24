import Mathlib

variable {G : Type} [CommGroup G]

def star (a b : G) : G := a * b⁻¹