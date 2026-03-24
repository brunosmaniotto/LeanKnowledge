import Mathlib

variable {R : Type} [Ring R]

theorem product_with_ring_negative (x y : R) : (-x) * y = -(x * y) ∧ -(x * y) = x * (-y) := by
  exact ⟨neg_mul x y, (mul_neg x y).symm⟩