import Mathlib

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n] {R : Type*} [CommRing R]

theorem det_product_eq_product_det (A B : Matrix n n R) :
    det (A * B) = det A * det B :=
  det_mul A B