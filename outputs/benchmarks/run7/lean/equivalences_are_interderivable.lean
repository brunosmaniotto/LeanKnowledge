import Mathlib

theorem interderivable_iff_iff (p q : Prop) : ((p → q) ∧ (q → p)) ↔ (p ↔ q) := by
  constructor
  · intro h
    exact ⟨h.1, h.2⟩
  · intro h
    exact ⟨h.1, h.2⟩