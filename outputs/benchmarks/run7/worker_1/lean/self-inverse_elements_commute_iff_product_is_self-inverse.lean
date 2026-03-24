import Mathlib

variable [Group G] {x y : G}

theorem self_inverse_comm_iff_product_self_inverse (hx : x * x = 1) (hy : y * y = 1) :
    (x * y = y * x) ↔ (x * y) * (x * y) = 1 := by
  constructor
  · intro h
    calc
      (x * y) * (x * y) = x * (y * x) * y := by simp [mul_assoc]
      _ = x * (x * y) * y := by rw [h]
      _ = (x * x) * (y * y) := by simp [mul_assoc]
      _ = 1 * 1 := by rw [hx, hy]
      _ = 1 := by simp
  · intro h
    have h_inv : (x * y)⁻¹ = x * y := by
      rw [inv_eq_iff_mul_eq_one, h]
    have hx_inv : x⁻¹ = x := by
      rw [inv_eq_iff_mul_eq_one, hx]
    have hy_inv : y⁻¹ = y := by
      rw [inv_eq_iff_mul_eq_one, hy]
    calc
      x * y = (x * y)⁻¹ := by rw [h_inv]
      _ = y⁻¹ * x⁻¹ := by rw [mul_inv_rev]
      _ = y * x := by rw [hx_inv, hy_inv]