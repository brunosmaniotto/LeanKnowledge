import Mathlib

theorem subset_transitivity {α : Type} {R S T : Set α} (hRS : R ⊆ S) (hST : S ⊆ T) : R ⊆ T := by
  intro x hx
  exact hST (hRS hx)