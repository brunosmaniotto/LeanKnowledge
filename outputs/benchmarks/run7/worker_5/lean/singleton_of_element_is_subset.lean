import Mathlib

open Set

theorem mem_iff_singleton_subset {α : Type} {S : Set α} {x : α} : x ∈ S ↔ ({x} : Set α) ⊆ S :=
  Iff.symm singleton_subset_iff