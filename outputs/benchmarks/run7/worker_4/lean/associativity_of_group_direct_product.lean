import Mathlib

def prod_assoc (G H K : Type*) [Group G] [Group H] [Group K] : G × (H × K) ≃* (G × H) × K :=
  { toFun := fun (g, hk) => ((g, hk.1), hk.2)
    invFun := fun ((g, h), k) => (g, (h, k))
    left_inv := fun ⟨g, ⟨h, k⟩⟩ => rfl
    right_inv := fun ⟨⟨g, h⟩, k⟩ => rfl
    map_mul' := fun ⟨g₁, ⟨h₁, k₁⟩⟩ ⟨g₂, ⟨h₂, k₂⟩⟩ => rfl }