import Mathlib
open Set

theorem demorgan_indexed {α : Type*} {ι : Type*} (S : ι → Set α) :
    (⋂ i, S i)ᶜ = ⋃ i, (S i)ᶜ ∧ (⋃ i, S i)ᶜ = ⋂ i, (S i)ᶜ := by
  exact ⟨compl_iInter S, compl_iUnion S⟩