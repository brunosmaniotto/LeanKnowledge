import Mathlib

variable {R : Type} [Ring R] {m n p : ℕ}

theorem matrix_mul_add (A : Matrix (Fin m) (Fin n) R) (B C : Matrix (Fin n) (Fin p) R) :
    A * (B + C) = A * B + A * C := by
  ext i j
  simp only [Matrix.mul_apply, Matrix.add_apply]
  calc
    ∑ k : Fin n, A i k * (B k j + C k j) = ∑ k : Fin n, (A i k * B k j + A i k * C k j) := by
      congr; ext k; rw [mul_add]
    _ = (∑ k : Fin n, A i k * B k j) + (∑ k : Fin n, A i k * C k j) := by rw [Finset.sum_add_distrib]