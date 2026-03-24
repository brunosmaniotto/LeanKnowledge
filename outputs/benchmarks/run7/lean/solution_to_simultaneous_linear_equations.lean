import Mathlib

open Matrix

theorem solution_iff_matrix_mulVec {K : Type u} [Field K] {m n : Type v} [Fintype n]
    (A : Matrix m n K) (x : n → K) (β : m → K) :
    (∀ i, ∑ j, A i j * x j = β i) ↔ A.mulVec x = β := by
  constructor
  · intro h
    ext i
    exact h i
  · intro h i
    simpa [Matrix.mulVec] using congrFun h i