import Mathlib

open Cardinal Set

variable {α : Type*} (s : Set α)

theorem card_eq_zero_iff_eq_empty : (#s) = 0 ↔ s = ∅ := by
  rw [Cardinal.mk_eq_zero_iff]
  constructor
  · intro h
    ext x
    constructor
    · intro hx
      exfalso
      exact h.elim ⟨x, hx⟩
    · intro h'
      exfalso
      simp at h'
  · intro h
    rw [h] at *
    exact inferInstance