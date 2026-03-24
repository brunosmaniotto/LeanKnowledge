import Mathlib.Data.Matrix.Basic

open Matrix

theorem transpose_transpose_eq (A : Matrix m n α) : (Aᵀ)ᵀ = A := by
  ext i j
  simp