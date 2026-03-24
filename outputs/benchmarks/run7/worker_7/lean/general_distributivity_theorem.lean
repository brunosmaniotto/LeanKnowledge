import Mathlib

open Finset

variable {R : Type} [CommSemiring R] (a b : ℕ → R)

theorem general_distributivity (m n : ℕ) :
    (∑ i ∈ Icc 1 m, a i) * (∑ j ∈ Icc 1 n, b j) = ∑ i ∈ Icc 1 m, ∑ j ∈ Icc 1 n, a i * b j :=
  Finset.sum_mul_sum (Icc 1 m) (Icc 1 n) a b