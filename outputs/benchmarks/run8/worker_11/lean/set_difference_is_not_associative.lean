import Mathlib
open Set

theorem set_diff_assoc_iff (R S T : Set α) : (R \ S) \ T = R \ (S \ T) ↔ R ∩ T = ∅ := by
  constructor
  · intro h_eq
    ext x
    constructor
    · intro hx
      rcases hx with ⟨hxR, hxT⟩
      have mem_right : x ∈ R \ (S \ T) := by
        refine ⟨hxR, ?_⟩
        intro h
        exact h.2 hxT
      have mem_left : x ∈ (R \ S) \ T := by
        rwa [← h_eq] at mem_right
      exfalso
      exact mem_left.2 hxT
    · intro h
      simp at h
  · intro h
    ext x
    constructor
    · intro hx
      rcases hx with ⟨⟨hxR, hxS⟩, hxT⟩
      refine ⟨hxR, ?_⟩
      intro h'
      rcases h' with ⟨h'S, h'T⟩
      exact hxS h'S
    · intro hx
      rcases hx with ⟨hxR, h_not⟩
      have hxT : x ∉ T := by
        intro hxT
        have : x ∈ R ∩ T := ⟨hxR, hxT⟩
        rw [h] at this
        simp at this
      have hxS : x ∉ S := by
        intro hxS
        have : x ∈ S \ T := ⟨hxS, hxT⟩
        exact h_not this
      exact ⟨⟨hxR, hxS⟩, hxT⟩