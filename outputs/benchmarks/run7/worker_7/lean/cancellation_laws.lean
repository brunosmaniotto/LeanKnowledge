import Mathlib

variable {G : Type} [Group G] {a b c : G}

theorem right_cancel (h : b * a = c * a) : b = c := by
  calc
    b = (b * a) * a⁻¹ := by rw [mul_inv_cancel_right]
    _ = (c * a) * a⁻¹ := by rw [h]
    _ = c := by rw [mul_inv_cancel_right]