import Mathlib

open Set

structure SetAlgebra (X : Type u) where
  sets : Set (Set X)
  empty_mem : ∅ ∈ sets
  compl_mem : ∀ A, A ∈ sets → Aᶜ ∈ sets
  union_mem : ∀ A B, A ∈ sets → B ∈ sets → A ∪ B ∈ sets

variable {X : Type u} (A : SetAlgebra X)

namespace SetAlgebra

theorem univ_mem : Set.univ ∈ A.sets := by
  rw [← compl_empty]
  exact A.compl_mem ∅ A.empty_mem