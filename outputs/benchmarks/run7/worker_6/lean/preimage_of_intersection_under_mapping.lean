import Mathlib

open Set

theorem preimage_inter {α β : Type*} (f : α → β) (T₁ T₂ : Set β) :
    f ⁻¹' (T₁ ∩ T₂) = f ⁻¹' T₁ ∩ f ⁻¹' T₂ := by
  ext x
  simp [mem_inter_iff, mem_preimage]