import Mathlib

open Matrix

variable (K : Type _) [Field K] [DecidableEq K] (m n : ℕ)

/-- Matrix equivalence: two matrices are equivalent if there exist invertible matrices P and Q
    such that P * A * Q = B. -/
def MatrixEquiv (A B : Matrix (Fin m) (Fin n) K) : Prop :=
  ∃ (P : Matrix (Fin m) (Fin m) K) (Q : Matrix (Fin n) (Fin n) K),
    IsUnit P ∧ IsUnit Q ∧ P * A * Q = B

-- Axiomatized dependencies (to be replaced with actual Mathlib lemmas)
axiom rank_le_min_dims (A : Matrix (Fin m) (Fin n) K) : rank A ≤ min m n

axiom exists_matrix_of_rank (r : ℕ) (hr : r ≤ min m n) :
  ∃ A : Matrix (Fin m) (Fin n) K, rank A = r

axiom equiv_iff_rank_eq (A B : Matrix (Fin m) (Fin n) K) :
  MatrixEquiv K m n A B ↔ rank A = rank B

-- Proof that MatrixEquiv is an equivalence relation