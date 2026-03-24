import Mathlib
open BigOperators

noncomputable def welfare_function {I : Type} [Fintype I] (α : I → Real) (β : Real) (y : I → Real) : Real := ∑ i, α i * (y i) ^ β

def feasible_allocations {I : Type} [Fintype I] (y_bar : Real) : Set (I → Real) := {y | (∀ i, 0 ≤ y i) ∧ (∑ i, y i = y_bar)}