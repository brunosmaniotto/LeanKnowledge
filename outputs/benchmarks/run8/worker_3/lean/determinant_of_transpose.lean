import Mathlib

open Matrix

theorem det_eq_det_transpose {n : Type*} [Fintype n] [DecidableEq n] {R : Type*} [CommRing R]
    (A : Matrix n n R) : A.det = (Aᵀ).det :=
  (det_transpose A).symm