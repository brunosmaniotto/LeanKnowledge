import Mathlib
open Set

/-- Set difference S \ T: all elements in S that are not in T. -/
abbrev setDifference {α : Type*} (S T : Set α) : Set α := S \ T

/-- The complement of S relative to the universal set U,
    expressed as the set difference U \ S. -/
abbrev complementAsDiff {α : Type*} (S : Set α) : Set α := Set.univ \ S