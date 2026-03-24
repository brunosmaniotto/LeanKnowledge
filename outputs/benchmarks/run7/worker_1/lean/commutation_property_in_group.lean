import Mathlib

variable {G : Type} [Group G]

theorem commute_iff_conj_eq (x y : G) : x * y = y * x ↔ x * y * x⁻¹ = y := by
  rw [mul_inv_eq_iff_eq_mul]