import Mathlib

open Set

theorem union_empty_iff {α : Type} (S T : Set α) : S ∪ T = ∅ ↔ S = ∅ ∧ T = ∅ := by
  constructor
  · intro h
    have hS : S = ∅ := by
      ext x
      constructor
      · intro hx
        have : x ∈ S ∪ T := Or.inl hx
        rw [h] at this
        simp at this
      · intro hx
        simp at hx
    have hT : T = ∅ := by
      ext x
      constructor
      · intro hx
        have : x ∈ S ∪ T := Or.inr hx
        rw [h] at this
        simp at this
      · intro hx
        simp at hx
    exact ⟨hS, hT⟩
  · rintro ⟨rfl, rfl⟩
    simp