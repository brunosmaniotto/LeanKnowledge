import Mathlib

theorem union_with_universe {α : Type*} (S : Set α) : S ∪ Set.univ = Set.univ := by
  ext x
  simp