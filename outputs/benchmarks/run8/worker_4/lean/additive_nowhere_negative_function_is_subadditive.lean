import Mathlib

variable {X : Type*}

structure IsAlgebra (𝒜 : Set (Set X)) : Prop where
  empty_mem : ∅ ∈ 𝒜
  compl_mem : ∀ {A}, A ∈ 𝒜 → Aᶜ ∈ 𝒜
  union_mem : ∀ {A B}, A ∈ 𝒜 → B ∈ 𝒜 → A ∪ B ∈ 𝒜

namespace IsAlgebra

lemma inter_mem (h : IsAlgebra 𝒜) (hA : A ∈ 𝒜) (hB : B ∈ 𝒜) : A ∩ B ∈ 𝒜 := by
  have hAc : Aᶜ ∈ 𝒜 := h.compl_mem hA
  have hBc : Bᶜ ∈ 𝒜 := h.compl_mem hB
  have h_union : Aᶜ ∪ Bᶜ ∈ 𝒜 := h.union_mem hAc hBc
  have : (Aᶜ ∪ Bᶜ)ᶜ = A ∩ B := by ext x; simp
  rw [← this]
  exact h.compl_mem h_union

end IsAlgebra