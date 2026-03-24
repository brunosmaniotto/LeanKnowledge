import Mathlib

open Matrix

theorem incidence_matrix_commutes_with_transpose {n : Type} [Fintype n] [DecidableEq n] {R : Type} [CommRing R]
    (A : Matrix n n R) (k l : R) (J : Matrix n n R)
    (h_symm : A * Aᵀ = (k - l) • (1 : Matrix n n R) + l • J)
    (h_dual : Aᵀ * A = (k - l) • (1 : Matrix n n R) + l • J) : A * Aᵀ = Aᵀ * A := by
  rw [h_symm, h_dual]