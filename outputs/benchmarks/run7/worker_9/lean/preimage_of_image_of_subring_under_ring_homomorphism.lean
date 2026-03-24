import Mathlib

open Set
open Pointwise

variable {R₁ R₂ : Type*} [Ring R₁] [Ring R₂] (φ : R₁ →+* R₂) (J : Subring R₁)

theorem preimage_image_eq_add : φ⁻¹' (φ '' (J : Set R₁)) = (J : Set R₁) + (RingHom.ker φ : Set R₁) := by
  ext x
  constructor
  · intro hx
    rw [mem_preimage, mem_image] at hx
    rcases hx with ⟨y, hy, hy'⟩
    have hmem : x - y ∈ RingHom.ker φ := by
      rw [RingHom.mem_ker]
      rw [RingHom.map_sub, hy', sub_self]
    refine ⟨y, hy, x - y, hmem, ?_⟩
    abel
  · intro hx
    rcases hx with ⟨j, hj, k, hk, rfl⟩
    rw [mem_preimage, mem_image]
    refine ⟨j, hj, ?_⟩
    rw [RingHom.map_add, RingHom.mem_ker.mp hk, add_zero]