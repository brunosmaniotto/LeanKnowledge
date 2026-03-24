import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Fin.Basic

open Matrix

theorem unit_matrix_is_identity (R : Type u) [Ring R] (n : ℕ) (hn : n > 0)
    (A : Matrix (Fin n) (Fin n) R) : A * 1 = A ∧ 1 * A = A := by
  simp