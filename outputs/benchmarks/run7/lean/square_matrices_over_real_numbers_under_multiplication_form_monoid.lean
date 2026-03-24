import Mathlib

theorem SquareMatricesOverRealNumbersUnderMultiplicationFormMonoid (n : ℕ) :
    (∀ (A B C : Matrix (Fin n) (Fin n) ℝ), (A * B) * C = A * (B * C)) ∧
    (∀ (A : Matrix (Fin n) (Fin n) ℝ), (1 : Matrix (Fin n) (Fin n) ℝ) * A = A) ∧
    (∀ (A : Matrix (Fin n) (Fin n) ℝ), A * (1 : Matrix (Fin n) (Fin n) ℝ) = A) := by
  exact ⟨Matrix.mul_assoc, Matrix.one_mul, Matrix.mul_one⟩