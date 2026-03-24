import Mathlib

lemma left_coset_membership_iff_inverse {G : Type*} [Group G] (H : Subgroup G) (x g : G) : 
  x ∈ (fun h => g * h) '' (H : Set G) ↔ x⁻¹ * g ∈ H := by
  constructor
  · intro h
    -- x ∈ g • H means x = g * h for some h ∈ H
    obtain ⟨h, hH, rfl⟩ := h
    -- We have x = g * h, so x⁻¹ * g = (g * h)⁻¹ * g = h⁻¹ * g⁻¹ * g = h⁻¹
    simp only [mul_inv_rev, inv_mul_cancel_right]
    exact H.inv_mem hH
  · intro h
    -- x⁻¹ * g ∈ H, so x = g * (x⁻¹ * g)⁻¹
    use (x⁻¹ * g)⁻¹
    constructor
    · exact H.inv_mem h
    · simp only [mul_inv_rev, inv_inv, mul_inv_cancel_left]