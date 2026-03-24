import Mathlib

open Matrix

variable {R : Type} [Field R]

def vandermonde_2 (x0 x1 : R) : Matrix (Fin 2) (Fin 2) R :=
  fun i j => match i, j with
  | 0, 0 => x0
  | 0, 1 => x1
  | 1, 0 => x0^2
  | 1, 1 => x1^2