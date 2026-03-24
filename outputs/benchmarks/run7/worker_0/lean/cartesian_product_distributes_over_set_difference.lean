import Mathlib

open Set

variable {α β : Type*}

theorem prod_diff_left (S : Set α) (T₁ T₂ : Set β) :
    S ×ˢ (T₁ \ T₂) = (S ×ˢ T₁) \ (S ×ˢ T₂) := by
  ext ⟨x, y⟩
  simp [mem_prod, mem_diff]
  tauto