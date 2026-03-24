import Mathlib

open Matrix Finset BigOperators

/-- In the two-good case, budget balancedness (Sp = 0) and homogeneity of
    degree zero (pᵀS = 0) imply the Slutsky matrix is symmetric (Claim 2.3(i),
    cf. Exercise 2.9). With normalized prices p = (1,1):
    - h_row0, h_row1: rows of Sp = 0
    - h_col0: first column of pᵀS = 0 -/
theorem Claim_2_3_i (S : Matrix (Fin 2) (Fin 2) ℝ)
    (h_row0 : S 0 0 + S 0 1 = 0)
    (h_row1 : S 1 0 + S 1 1 = 0)
    (h_col0 : S 0 0 + S 1 0 = 0) :
    Sᵀ = S := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Matrix.transpose_apply] <;> linarith