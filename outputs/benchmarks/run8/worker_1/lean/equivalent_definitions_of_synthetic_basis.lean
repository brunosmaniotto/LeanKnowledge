import Mathlib

open Set

theorem equivalent_definitions_synthetic_basis (X : Type*) (ℬ : Set (Set X)) :
    (∀ A ∈ ℬ, ∀ B ∈ ℬ, ∃ (𝒜 : Set (Set X)), 𝒜 ⊆ ℬ ∧ A ∩ B = ⋃₀ 𝒜) ↔
    (∀ A ∈ ℬ, ∀ B ∈ ℬ, ∀ x ∈ A ∩ B, ∃ W ∈ ℬ, x ∈ W ∧ W ⊆ A ∩ B) := by
  constructor
  · intro h A hA B hB x hx
    rcases h A hA B hB with ⟨𝒜, h𝒜_sub, h_eq⟩
    have hx_sUnion : x ∈ ⋃₀ 𝒜 := by rw [← h_eq]; exact hx
    rcases mem_sUnion.1 hx_sUnion with ⟨W, hW, hxW⟩
    have hW_sub : W ⊆ A ∩ B := by
      intro y hy
      rw [h_eq]
      exact mem_sUnion.2 ⟨W, hW, hy⟩
    exact ⟨W, h𝒜_sub hW, hxW, hW_sub⟩
  · intro h A hA B hB
    let 𝒜 : Set (Set X) := {W | W ∈ ℬ ∧ W ⊆ A ∩ B}
    have h𝒜_sub : 𝒜 ⊆ ℬ := by intro W hW; exact hW.1
    refine ⟨𝒜, h𝒜_sub, ?_⟩
    ext x
    constructor
    · intro hx
      rcases h A hA B hB x hx with ⟨W, hW, hxW, hW_sub⟩
      exact mem_sUnion.2 ⟨W, ⟨hW, hW_sub⟩, hxW⟩
    · intro hx
      rcases mem_sUnion.1 hx with ⟨W, ⟨hW, hW_sub⟩, hxW⟩
      exact hW_sub hxW