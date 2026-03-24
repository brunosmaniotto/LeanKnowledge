import Mathlib

variable {M1 M2 : Type} [One M1] [One M2]

def pr1 : M1 × M2 → M1 := Prod.fst