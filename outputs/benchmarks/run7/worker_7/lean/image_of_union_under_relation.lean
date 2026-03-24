import Mathlib

theorem rel_image_union {S T : Type} (r : Set (S × T)) (S₁ S₂ : Set S) :
    { t | ∃ s ∈ S₁ ∪ S₂, (s, t) ∈ r } = { t | ∃ s ∈ S₁, (s, t) ∈ r } ∪ { t | ∃ s ∈ S₂, (s, t) ∈ r } := by
  ext t
  constructor
  · intro h
    rcases h with ⟨s, hs, hst⟩
    rw [Set.mem_union] at hs
    rcases hs with (hs₁ | hs₂)
    · left
      exact ⟨s, hs₁, hst⟩
    · right
      exact ⟨s, hs₂, hst⟩
  · intro h
    rcases h with (⟨s, hs, hst⟩ | ⟨s, hs, hst⟩)
    · exact ⟨s, Or.inl hs, hst⟩
    · exact ⟨s, Or.inr hs, hst⟩