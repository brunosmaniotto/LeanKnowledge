import Mathlib

open Set

theorem subset_iff_sdiff_eq_empty (S T : Set α) : S ⊆ T ↔ S \ T = ∅ := by
  constructor
  · intro h
    ext x
    constructor
    · intro hx
      exfalso
      exact hx.2 (h hx.1)
    · intro hx
      exfalso
      simp at hx
  · intro h
    intro x hxS
    by_contra hxT
    have hx : x ∈ S \ T := ⟨hxS, hxT⟩
    rw [h] at hx
    simp at hx