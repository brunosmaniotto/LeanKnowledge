import Mathlib

theorem boolean_is_abelian (G : Type*) [Group G] (h : ∀ x : G, x * x = 1) : ∀ x y : G, x * y = y * x := by
  have h_inv : ∀ x : G, x⁻¹ = x := by
    intro x
    exact (inv_eq_iff_mul_eq_one.mpr (h x))
  intro x y
  calc
    x * y = (x * y)⁻¹ := by rw [h_inv]
    _ = y⁻¹ * x⁻¹ := by rw [mul_inv_rev]
    _ = y * x := by rw [h_inv y, h_inv x]