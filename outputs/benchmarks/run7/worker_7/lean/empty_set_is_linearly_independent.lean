import Mathlib

variable (F : Type u) [Field F] (V : Type v) [AddCommGroup V] [Module F V]

theorem EmptySetIsLinearlyIndependent : LinearIndependent F ((↑) : (∅ : Set V) → V) := by
  rw [linearIndependent_iff]
  intro l h
  ext x
  exfalso
  exact x.2