import Mathlib

open Matrix
open BigOperators
open Topology

variable {n : Type} [Fintype n] [DecidableEq n]
variable {R : Type} [CommRing R]

-- Laplace expansion along a single row (k=1)
theorem laplace_expansion_row (A : Matrix n n R) (i : n) :
    det A = ∑ j : n, A i j * adjugate A j i :=
  det_eq_sum_mul_adjugate_row A i

-- Laplace expansion along a single column (k=1)