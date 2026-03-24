import Mathlib

variable {S T : Type} [MulOneClass S] [MulOneClass T] [IsCancelMul T]

theorem MulHom.map_one_of_cancel (φ : S →ₙ* T) : φ 1 = 1 := by
  have h_idem : φ 1 * φ 1 = φ 1 := by
    calc
      φ 1 * φ 1 = φ (1 * 1) := by rw [map_mul]
      _ = φ 1 := by rw [mul_one]
  have h : φ 1 * φ 1 = φ 1 * 1 := by
    rw [h_idem, mul_one]
  exact mul_left_cancel h