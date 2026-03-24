import Mathlib

open Set

variable {T₁ T₂ : Type*} [TopologicalSpace T₁] [TopologicalSpace T₂]

theorem compactSpace_prod_iff :
    CompactSpace (T₁ × T₂) ↔ (Nonempty T₂ → CompactSpace T₁) ∧ (Nonempty T₁ → CompactSpace T₂) := by
  constructor
  · intro h
    have h_comp : IsCompact (univ : Set (T₁ × T₂)) := isCompact_univ
    constructor
    · intro h2
      have h_image : Prod.fst '' (univ : Set (T₁ × T₂)) = (univ : Set T₁) := by
        ext x
        constructor
        · intro _; exact mem_univ x
        · intro _
          rcases h2 with ⟨y⟩
          exact ⟨(x, y), mem_univ _, rfl⟩
      have h1 : IsCompact (Prod.fst '' (univ : Set (T₁ × T₂))) :=
        h_comp.image continuous_fst
      rw [h_image] at h1
      exact ⟨h1⟩
    · intro h1
      have h_image : Prod.snd '' (univ : Set (T₁ × T₂)) = (univ : Set T₂) := by
        ext y
        constructor
        · intro _; exact mem_univ y
        · intro _
          rcases h1 with ⟨x⟩
          exact ⟨(x, y), mem_univ _, rfl⟩
      have h2 : IsCompact (Prod.snd '' (univ : Set (T₁ × T₂))) :=
        h_comp.image continuous_snd
      rw [h_image] at h2
      exact ⟨h2⟩
  · rintro ⟨h1, h2⟩
    by_cases h1' : Nonempty T₁
    · by_cases h2' : Nonempty T₂
      · have hT1 : CompactSpace T₁ := h1 h2'
        have hT2 : CompactSpace T₂ := h2 h1'
        exact inferInstance
      · have : IsEmpty T₂ := ⟨by
          intro y
          exfalso
          exact h2' ⟨y⟩⟩
        exact inferInstance
    · have : IsEmpty T₁ := ⟨by
        intro x
        exfalso
        exact h1' ⟨x⟩⟩
      exact inferInstance