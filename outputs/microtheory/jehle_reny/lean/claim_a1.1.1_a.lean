import Mathlib

theorem claim_A1_1_1_a (A B : Prop) :
    (B → A) ↔ (B → A) := by
  exact Iff.rfl