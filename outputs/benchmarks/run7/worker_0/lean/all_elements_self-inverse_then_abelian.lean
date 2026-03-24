import Mathlib

theorem self_inverse_implies_abelian (G : Type*) [Group G] (h : ∀ x : G, x * x = 1) : ∀ x y : G, x * y = y * x := by
  intro x y
  have h_inv : ∀ x : G, x⁻¹ = x := by
    intro x
    exact inv_eq_iff_mul_eq_one.mpr (h x)
  calc
    x * y = (x * y)⁻¹ := Eq.symm (h_inv (x * y))
    _ = y⁻¹ * x⁻¹ := by rw [mul_inv_rev]
    _ = y * x := by rw [h_inv y, h_inv x]