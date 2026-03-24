import Mathlib

open Matrix

variable {α : Type*} {n : ℕ} (x : Matrix (Fin 1) (Fin n) α)

theorem transpose_of_row_matrix_is_column_matrix : xᵀ = (fun i (_ : Fin 1) => x 0 i) := by
  ext i j
  simp [Matrix.transpose_apply, Fin.eq_zero j]