import Mathlib

variable {R : Type} [Ring R] {n : Type} [Fintype n]

theorem matrix_mul_closed (A B : Matrix n n R) : A * B ∈ (Set.univ : Set (Matrix n n R)) := by
  simp