import Mathlib

variable {S T : Type*} (f : S → T) (T₁ T₂ : Set T)

theorem preimage_union_eq_union_preimage : f ⁻¹' (T₁ ∪ T₂) = f ⁻¹' T₁ ∪ f ⁻¹' T₂ :=
  Set.preimage_union