import Mathlib

open Set

theorem set_diff_eq_iff_inter_eq (R S T : Set α) : R \ S = R \ T ↔ R ∩ S = R ∩ T := by
  have h1 : R \ S = R \ T ↔ ∀ x, x ∈ R → (x ∈ S ↔ x ∈ T) := by
    constructor
    · intro h x hxR
      constructor
      · intro hxS
        by_contra hxT
        have hx : x ∈ R \ T := ⟨hxR, hxT⟩
        rw [← h] at hx
        exact hx.2 hxS
      · intro hxT
        by_contra hxS
        have hx : x ∈ R \ S := ⟨hxR, hxS⟩
        rw [h] at hx
        exact hx.2 hxT
    · intro h
      ext x
      constructor
      · intro hx
        exact ⟨hx.1, fun hxT => hx.2 ((h x hx.1).2 hxT)⟩
      · intro hx
        exact ⟨hx.1, fun hxS => hx.2 ((h x hx.1).1 hxS)⟩
  have h2 : R ∩ S = R ∩ T ↔ ∀ x, x ∈ R → (x ∈ S ↔ x ∈ T) := by
    constructor
    · intro h x hxR
      constructor
      · intro hxS
        have : x ∈ R ∩ S := ⟨hxR, hxS⟩
        rw [h] at this
        exact this.2
      · intro hxT
        have : x ∈ R ∩ T := ⟨hxR, hxT⟩
        rw [← h] at this
        exact this.2
    · intro h
      ext x
      constructor
      · intro hx
        exact ⟨hx.1, (h x hx.1).1 hx.2⟩
      · intro hx
        exact ⟨hx.1, (h x hx.1).2 hx.2⟩
  rw [h1, h2]