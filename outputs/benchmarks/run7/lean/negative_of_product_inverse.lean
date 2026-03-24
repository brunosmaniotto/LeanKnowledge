import Mathlib

theorem negative_of_product_inverse {R : Type _} [Ring R] (z : Units R) : (-z)⁻¹ = -(z⁻¹) := by
  ext
  simp [neg_mul_neg]