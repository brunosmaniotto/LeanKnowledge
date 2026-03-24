import Mathlib

open Matrix
open Equiv

theorem Determinant_with_Rows_Transposed {n : Type} [Fintype n] [DecidableEq n] {R : Type} [CommRing R]
    (A : Matrix n n R) (i j : n) (h : i ≠ j) : det (A.submatrix (swap i j) id) = -det A := by
  rw [Matrix.det_permute]
  rw [Equiv.Perm.sign_swap h]
  simp