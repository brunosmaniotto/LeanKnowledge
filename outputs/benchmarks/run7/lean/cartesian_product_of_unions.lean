import Mathlib

open Set

theorem cartesian_product_union {α β : Type _} (S₁ S₂ : Set α) (T₁ T₂ : Set β) :
    (S₁ ∪ S₂) ×ˢ (T₁ ∪ T₂) = (S₁ ×ˢ T₁) ∪ (S₂ ×ˢ T₂) ∪ (S₁ ×ˢ T₂) ∪ (S₂ ×ˢ T₁) := by
  ext ⟨x, y⟩
  simp only [mem_prod, mem_union]
  tauto