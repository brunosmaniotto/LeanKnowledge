import Mathlib

open Matrix

variable {n : Type _} [Fintype n] [DecidableEq n] {R : Type _} [CommRing R]

theorem A_mul_adjugate_eq_det_smul_id (A : Matrix n n R) :
    A * adjugate A = (det A) • (1 : Matrix n n R) :=
  mul_adjugate A