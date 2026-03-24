import Mathlib

variable {S T : Type} [MulOneClass S] [Group T] (φ : S →ₙ* T)

theorem homomorphism_to_group_preserves_identity : φ 1 = 1 := by
  have h3 : φ 1 = φ 1 * φ 1 := by
    rw [← φ.map_mul, one_mul]
  have h4 : φ 1 * φ 1 = φ 1 * 1 := by
    rw [h3.symm, mul_one]
  exact mul_left_cancel h4