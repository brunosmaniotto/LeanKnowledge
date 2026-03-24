import Mathlib

theorem equiv_condition (G : Type u) [Group G] :
    (∀ a b : G, (a * b)⁻¹ = a⁻¹ * b⁻¹) ↔ (∀ a b : G, a * b = b * a) := by
  constructor
  · intro h_inv a b
    calc
      a * b = ((a * b)⁻¹)⁻¹ := by rw [inv_inv]
      _ = (a⁻¹ * b⁻¹)⁻¹ := by rw [h_inv a b]
      _ = (b⁻¹)⁻¹ * (a⁻¹)⁻¹ := by rw [mul_inv_rev]
      _ = b * a := by rw [inv_inv, inv_inv]
  · intro h_comm a b
    calc
      (a * b)⁻¹ = (b * a)⁻¹ := by rw [h_comm a b]
      _ = a⁻¹ * b⁻¹ := by rw [mul_inv_rev]