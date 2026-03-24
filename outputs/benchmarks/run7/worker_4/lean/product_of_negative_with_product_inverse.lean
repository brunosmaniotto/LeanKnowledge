import Mathlib

-- Sub-lemma 1: negation distributes over multiplication with unit inverse (left)
lemma neg_mul_unit_inv {R : Type*} [Ring R] (x : R) (z : Rˣ) : -(x * ↑z⁻¹) = (-x) * ↑z⁻¹ := by
  rw [neg_mul]

-- Sub-lemma 2: negation distributes over multiplication with unit inverse (right)