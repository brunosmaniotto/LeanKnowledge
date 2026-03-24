import Mathlib

/-- A is necessary and sufficient for B (A ⇔ B) iff both A ⇒ B and A ⇐ B hold.
    This is exactly `Iff` in Lean 4. -/
abbrev necessary_and_sufficient (A B : Prop) : Prop := A ↔ B