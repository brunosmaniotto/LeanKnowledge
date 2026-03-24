import Mathlib

open Matrix

theorem transpose_of_matrix_product {m n p : Type*} [Fintype n] [CommSemiring R]
    (A : Matrix m n R) (B : Matrix n p R) : (A * B)ᵀ = Bᵀ * Aᵀ :=
  Matrix.transpose_mul A B