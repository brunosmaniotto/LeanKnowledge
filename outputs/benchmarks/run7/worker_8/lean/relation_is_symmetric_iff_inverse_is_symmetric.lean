import Mathlib.Logic.Relation

theorem symmetric_inv_iff {α : Type} (r : α → α → Prop) : Symmetric r ↔ Symmetric (flip r) := by
  constructor
  · intro h x y hxy
    exact h hxy
  · intro h x y hxy
    exact h hxy