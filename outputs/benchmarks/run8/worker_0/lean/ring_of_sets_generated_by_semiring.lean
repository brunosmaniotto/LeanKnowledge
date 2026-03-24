import Mathlib

open Set

variable {α : Type u}

structure IsSemiring (S : Set (Set α)) : Prop where
  empty_mem : ∅ ∈ S
  inter_mem : ∀ A B, A ∈ S → B ∈ S → A ∩ B ∈ S
  diff_eq_finite_disjoint_union : ∀ A B, A ∈ S → B ∈ S → ∃ (t : Finset (Set α)), (∀ c ∈ t, c ∈ S) ∧ (t : Set (Set α)).Pairwise Disjoint ∧ A \ B = ⋃ c ∈ t, c

structure IsRing (R : Set (Set α)) : Prop where
  empty_mem : ∅ ∈ R
  union_mem : ∀ A B, A ∈ R → B ∈ R → A ∪ B ∈ R
  diff_mem : ∀ A B, A ∈ R → B ∈ R → A \ B ∈ R

def generateRing (S : Set (Set α)) : Set (Set α) :=
  ⋂ (R : Set (Set α)) (hR : IsRing R) (hS : S ⊆ R), R