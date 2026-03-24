import Mathlib

open Matrix Finset BigOperators

theorem slutsky_symmetric_L2 (S : Matrix (Fin 2) (Fin 2) ℝ)
    (h0 : S 0 0 + S 0 1 = 0)
    (h1 : S 1 0 + S 1 1 = 0)
    (h2 : S 0 0 + S 1 0 = 0)
    (h3 : S 0 1 + S 1 1 = 0) :
    Sᵀ = S := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.transpose_apply] <;> linarith