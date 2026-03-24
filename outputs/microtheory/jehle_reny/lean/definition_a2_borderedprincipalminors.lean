import Mathlib
open Matrix
open Topology

/-- The bordered principal minor D̄_k: determinant of the leading
    (m + k) × (m + k) submatrix of the bordered Hessian Hbar.
    For the second-order conditions, k ranges from m+1 to n,
    giving the n−m minors from order 2m+1 to order m+n. -/
noncomputable def MWG.borderedPrincipalMinor {m n : ℕ}
    (Hbar : Matrix (Fin (m + n)) (Fin (m + n)) ℝ)
    (k : ℕ) (hk : k ≤ n) : ℝ :=
  (Hbar.submatrix (Fin.castLE (show m + k ≤ m + n by omega))
                  (Fin.castLE (show m + k ≤ m + n by omega))).det

/-- The set of indices k for which bordered principal minors are
    relevant to the second-order conditions: k = m+1, …, n. -/
def MWG.borderedMinorIndices (m n : ℕ) : Set ℕ :=
  {k | m + 1 ≤ k ∧ k ≤ n}