import Mathlib

open Matrix BigOperators

noncomputable section

variable {N : ℕ} [NeZero N]

def leadingPrincipalMinor (M : Matrix (Fin N) (Fin N) ℝ) (r : Fin N) : ℝ :=
  (M.submatrix (Fin.castLE (Nat.succ_le_of_lt r.isLt)) (Fin.castLE (Nat.succ_le_of_lt r.isLt))).det