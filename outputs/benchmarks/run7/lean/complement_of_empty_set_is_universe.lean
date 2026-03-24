import Mathlib

open Set

theorem complement_empty_eq_universe {α : Type*} : (∅ : Set α)ᶜ = (univ : Set α) := by
  ext x
  simp