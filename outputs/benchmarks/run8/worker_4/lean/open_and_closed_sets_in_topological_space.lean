import Mathlib

theorem whole_space_and_empty_are_clopen (X : Type*) [TopologicalSpace X] :
    IsOpen (∅ : Set X) ∧ IsClosed (∅ : Set X) ∧ IsOpen (Set.univ : Set X) ∧ IsClosed (Set.univ : Set X) := by
  exact ⟨isOpen_empty, isClosed_empty, isOpen_univ, isClosed_univ⟩