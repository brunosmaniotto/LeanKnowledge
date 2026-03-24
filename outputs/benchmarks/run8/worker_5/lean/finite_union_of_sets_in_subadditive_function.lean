import Mathlib

open Set
open Finset
open BigOperators

variable {α : Type _}

structure IsAlgebra (𝒜 : Set (Set α)) : Prop where
  empty_mem : ∅ ∈ 𝒜
  compl_mem : ∀ A, A ∈ 𝒜 → Aᶜ ∈ 𝒜
  union_mem : ∀ A B, A ∈ 𝒜 → B ∈ 𝒜 → A ∪ B ∈ 𝒜

structure SubadditiveOn (𝒜 : Set (Set α)) (f : Set α → EReal) : Prop where
  empty : f ∅ = 0
  subadd : ∀ A B, A ∈ 𝒜 → B ∈ 𝒜 → f (A ∪ B) ≤ f A + f B

lemma sUnion_mem {𝒜 : Set (Set α)} (h𝒜 : IsAlgebra 𝒜) (s : Finset (Set α)) 
    (h : ∀ A ∈ s, A ∈ 𝒜) : (⋃ A ∈ (s : Set (Set α)), A) ∈ 𝒜 := by
  induction s using Finset.induction_on with
  | empty =>
      simp [h𝒜.empty_mem]
  | insert a s ha ih =>
      have ha' : a ∈ 𝒜 := h a (mem_insert_self a s)
      have h' : ∀ A ∈ s, A ∈ 𝒜 := fun A hA => h A (mem_insert_of_mem hA)
      rw [coe_insert, Set.biUnion_insert]
      exact h𝒜.union_mem _ _ ha' (ih h')