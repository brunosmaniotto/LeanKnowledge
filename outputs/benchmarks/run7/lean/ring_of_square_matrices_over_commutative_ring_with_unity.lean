import Mathlib
open Matrix

variable (R : Type u) [CommRing R]

-- For n=1, the matrix ring over a commutative ring is commutative
theorem matrix_ring_commutative_for_n1 :
    ∀ A B : Matrix (Fin 1) (Fin 1) R, A * B = B * A := by
  intro A B
  ext i j
  fin_cases i
  fin_cases j
  simp [Matrix.mul_apply, Fin.sum_univ_one, mul_comm]

-- For n≥2 and nontrivial R, the matrix ring is not commutative