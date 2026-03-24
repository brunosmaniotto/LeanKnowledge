import Mathlib

open Set

/-- The union of an indexed collection of sets ∪_{i∈I} S_i. -/
abbrev indexedUnion {I : Type*} {α : Type*} (S : I → Set α) : Set α :=
  ⋃ i, S i

/-- The intersection of an indexed collection of sets ∩_{i∈I} S_i. -/
abbrev indexedInter {I : Type*} {α : Type*} (S : I → Set α) : Set α :=
  ⋂ i, S i