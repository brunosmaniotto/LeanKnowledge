import Mathlib

open TopologicalSpace Set
open Topology

/-- In ℝ^n: (1) ∅ is closed, (2) ℝ^n is closed, (3) finite union of closed sets is closed,
    (4) arbitrary intersection of closed sets is closed. -/
theorem Theorem_A1_4 (n : ℕ) :
    (IsClosed (∅ : Set (EuclideanSpace ℝ (Fin n)))) ∧
    (IsClosed (Set.univ : Set (EuclideanSpace ℝ (Fin n)))) ∧
    (∀ (S T : Set (EuclideanSpace ℝ (Fin n))), IsClosed S → IsClosed T → IsClosed (S ∪ T)) ∧
    (∀ (ι : Type) (S : ι → Set (EuclideanSpace ℝ (Fin n))),
      (∀ i, IsClosed (S i)) → IsClosed (⋂ i, S i)) :=
  ⟨isClosed_empty, isClosed_univ, fun _ _ hS hT => hS.union hT,
   fun _ _ hS => isClosed_iInter hS⟩