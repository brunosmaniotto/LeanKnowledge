import Mathlib

lemma product_not_in_first_subgroup {G : Type*} [Group G] (H K : Subgroup G) (h k : G) (hh : h ∈ H) (hk_not : k ∉ H) : h * k ∈ H → k ∈ H := by
  intro hprod
  -- We have h * k ∈ H and h ∈ H
  -- Since H is a subgroup, h⁻¹ ∈ H
  have h_inv_in_H : h⁻¹ ∈ H := H.inv_mem hh
  -- Since H is closed under multiplication and h⁻¹ ∈ H and h * k ∈ H
  -- we have h⁻¹ * (h * k) ∈ H
  have : h⁻¹ * (h * k) ∈ H := H.mul_mem h_inv_in_H hprod
  -- But h⁻¹ * (h * k) = (h⁻¹ * h) * k = 1 * k = k
  rw [← mul_assoc, inv_mul_cancel, one_mul] at this
  exact this