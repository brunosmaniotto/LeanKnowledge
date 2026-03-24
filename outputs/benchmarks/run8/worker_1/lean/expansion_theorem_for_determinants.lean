import Mathlib

open Matrix
open BigOperators

variable {n : Type*} [Fintype n] [DecidableEq n] {R : Type*} [CommRing R]

theorem expansion_row (A : Matrix n n R) (r : n) :
    det A = ∑ k : n, A r k * (adjugate A) k r := by
  rw [det_eq_sum_mul_adjugate_row A r]