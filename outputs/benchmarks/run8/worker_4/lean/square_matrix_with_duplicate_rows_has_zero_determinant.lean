import Mathlib

open Matrix

variable {n : Type} [Fintype n] [DecidableEq n] {R : Type} [CommRing R]

theorem Square_Matrix_with_Duplicate_Rows_has_Zero_Determinant (A : Matrix n n R) 
    (h : ∃ i j, i ≠ j ∧ A i = A j) : det A = 0 := by
  rcases h with ⟨i, j, hne, h⟩
  exact det_zero_of_row_eq hne h