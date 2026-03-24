import Mathlib

open Set
open scoped symmDiff

structure SetRing (α : Type*) where
  sets : Set (Set α)
  empty_mem : ∅ ∈ sets
  univ_mem : univ ∈ sets
  symmDiff_mem : ∀ ⦃s t⦄, s ∈ sets → t ∈ sets → s ∆ t ∈ sets
  inter_mem : ∀ ⦃s t⦄, s ∈ sets → t ∈ sets → s ∩ t ∈ sets

instance (𝒜 : SetRing α) : CommRing {s : Set α // s ∈ 𝒜.sets} := by
  sorry