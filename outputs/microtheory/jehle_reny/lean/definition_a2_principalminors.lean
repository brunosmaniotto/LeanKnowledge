import Mathlib

open Matrix
open Topology

/-- The i-th leading principal minor of an n×n matrix H is the determinant
    of the submatrix formed by the first i rows and first i columns of H,
    i.e., moving down the principal diagonal. D_i(x) = det(H[0..i-1, 0..i-1]). -/
noncomputable def leadingPrincipalMinor {n : ℕ}
    (H : Matrix (Fin n) (Fin n) ℝ) (i : ℕ) (hi : i ≤ n) : ℝ :=
  (H.submatrix (Fin.castLE hi) (Fin.castLE hi)).det