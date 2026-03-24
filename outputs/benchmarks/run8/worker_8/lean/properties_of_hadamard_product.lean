import Mathlib

open Matrix

variable {m n S : Type*}

/- Closure is inherent: `A ⊙ B` is a matrix of the same dimensions. -/

theorem hadamard_assoc [Semigroup S] (A B C : Matrix m n S) : (A ⊙ B) ⊙ C = A ⊙ (B ⊙ C) := by
  ext i j
  simp [hadamard, mul_assoc]