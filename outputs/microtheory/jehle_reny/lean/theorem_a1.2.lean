import Mathlib

open Set TopologicalSpace
open Topology

theorem theorem_A1_2 (n : ℕ) :
    (IsOpen (∅ : Set (EuclideanSpace ℝ (Fin n)))) ∧
    (IsOpen (Set.univ : Set (EuclideanSpace ℝ (Fin n)))) ∧
    (∀ (ι : Type) (S : ι → Set (EuclideanSpace ℝ (Fin n))),
      (∀ i, IsOpen (S i)) → IsOpen (⋃ i, S i)) ∧
    (∀ (S T : Set (EuclideanSpace ℝ (Fin n))),
      IsOpen S → IsOpen T → IsOpen (S ∩ T)) :=
  ⟨isOpen_empty, isOpen_univ, fun _ S hS => isOpen_iUnion hS, fun _ _ hS hT => hS.inter hT⟩