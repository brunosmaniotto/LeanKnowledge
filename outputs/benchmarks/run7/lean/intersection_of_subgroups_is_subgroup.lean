import Mathlib

variable {G : Type*} [Group G]

def intersection_subgroup (H₁ H₂ : Subgroup G) : Subgroup G where
  carrier := (H₁ : Set G) ∩ (H₂ : Set G)
  one_mem' := ⟨H₁.one_mem, H₂.one_mem⟩
  mul_mem' ha hb := ⟨H₁.mul_mem ha.1 hb.1, H₂.mul_mem ha.2 hb.2⟩
  inv_mem' ha := ⟨H₁.inv_mem ha.1, H₂.inv_mem ha.2⟩