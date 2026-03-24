import Mathlib

open Set

theorem complement_universe_eq_empty : (Set.univ : Set α)ᶜ = (∅ : Set α) := by
  exact Set.compl_univ