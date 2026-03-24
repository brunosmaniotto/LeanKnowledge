import Mathlib

/-- The statements 'A is sufficient for B', 'A is true only if B is true',
and 'A implies B' (A ⇒ B) are logically equivalent. -/
theorem claim_A1_1_1_c (A B : Prop) :
    ((A → B) ↔ (A → B)) ∧ ((A → B) ↔ (A → B)) ∧ ((A → B) ↔ (A → B)) :=
  ⟨Iff.rfl, Iff.rfl, Iff.rfl⟩