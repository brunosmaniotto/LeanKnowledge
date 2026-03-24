import Mathlib

variable {α : Type*} {S : Set (Set α)}

/-- A set U is a unit of a system of sets S if U ∈ S and for every A ∈ S, A ∩ U = A. -/
def IsUnitOfSystem (U : Set α) : Prop := U ∈ S ∧ ∀ A ∈ S, A ∩ U = A