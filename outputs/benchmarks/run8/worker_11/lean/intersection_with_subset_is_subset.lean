import Mathlib

variable {α : Type*} {S T : Set α}

theorem subset_iff_inter_eq_left : S ⊆ T ↔ S ∩ T = S := by
  constructor
  · intro h
    ext x
    constructor
    · intro hx
      exact hx.1
    · intro hx
      exact ⟨hx, h hx⟩
  · intro h x hx
    have : x ∈ S ∩ T := by rw [h]; exact hx
    exact this.2