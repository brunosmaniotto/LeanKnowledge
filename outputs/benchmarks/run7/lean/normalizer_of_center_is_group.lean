import Mathlib

variable {G : Type*} [Group G]

theorem mem_center_iff_conjugate_eq (x : G) :
    x ∈ Subgroup.center G ↔ ∀ g : G, g * x * g⁻¹ = x := by
  constructor
  · intro hx g
    rw [Subgroup.mem_center_iff] at hx
    calc g * x * g⁻¹ 
      = (g * x) * g⁻¹ := by rw [mul_assoc]
      _ = (x * g) * g⁻¹ := by rw [hx g]
      _ = x * (g * g⁻¹) := by rw [← mul_assoc]
      _ = x * 1 := by rw [mul_inv_cancel]
      _ = x := by rw [mul_one]
      
  · intro h
    rw [Subgroup.mem_center_iff]
    intro g
    have h_conj := h g
    calc g * x 
      = g * x * 1 := by rw [mul_one]
      _ = g * x * (g⁻¹ * g) := by rw [← inv_mul_cancel]
      _ = (g * x * g⁻¹) * g := by rw [← mul_assoc]
      _ = x * g := by rw [h_conj]