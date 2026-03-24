import Mathlib

open Set

/-- The image of a subgroup under a group homomorphism is a subgroup. -/
def image_subgroup {G₁ G₂ : Type*} [Group G₁] [Group G₂] 
    (φ : G₁ →* G₂) (H : Subgroup G₁) : Subgroup G₂ where
  carrier := φ '' (H : Set G₁)
  one_mem' := by
    exact ⟨1, H.one_mem, φ.map_one⟩
  mul_mem' := by
    rintro x y ⟨a, ha, rfl⟩ ⟨b, hb, rfl⟩
    exact ⟨a * b, H.mul_mem ha hb, φ.map_mul a b⟩
  inv_mem' := by
    rintro x ⟨a, ha, rfl⟩
    exact ⟨a⁻¹, H.inv_mem ha, φ.map_inv a⟩