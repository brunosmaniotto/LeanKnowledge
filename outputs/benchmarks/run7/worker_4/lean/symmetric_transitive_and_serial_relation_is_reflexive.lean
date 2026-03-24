import Mathlib

variable {α : Type*} (R : α → α → Prop)

theorem symmetric_transitive_serial_imp_reflexive (h_symm : Symmetric R) (h_trans : Transitive R)
    (h_serial : ∀ x, ∃ y, R x y) : ∀ x, R x x := by
  intro x
  obtain ⟨y, hxy⟩ := h_serial x
  have hyx : R y x := h_symm hxy
  exact h_trans hxy hyx