import Mathlib

theorem preimage_set_diff {S T : Type*} (f : S → T) (T₁ T₂ : Set T) :
    f ⁻¹' (T₁ \ T₂) = f ⁻¹' T₁ \ f ⁻¹' T₂ :=
Set.preimage_diff f T₁ T₂