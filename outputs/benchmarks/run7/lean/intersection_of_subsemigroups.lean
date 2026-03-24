import Mathlib

variable {S : Type*} [Semigroup S] (T₁ T₂ : Subsemigroup S)

theorem intersection_subsemigroup :
    ∃ T : Subsemigroup S, T ≤ T₁ ∧ T ≤ T₂ ∧ 
    (∀ x ∈ T₁, x ∈ T₂ → x ∈ T) ∧ (∀ x ∈ T, x ∈ T₁ ∧ x ∈ T₂) := by
  use T₁ ⊓ T₂
  constructor
  · exact inf_le_left
  constructor  
  · exact inf_le_right
  constructor
  · intros x hx1 hx2
    exact ⟨hx1, hx2⟩
  · intro x hx
    exact hx