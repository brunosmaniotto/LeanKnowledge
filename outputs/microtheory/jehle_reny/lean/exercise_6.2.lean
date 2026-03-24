import Mathlib

-- Define types for individuals and alternatives
variable {I A : Type*} [Inhabited I] [Inhabited A] [Fintype I] [Fintype A]

-- A strict preference relation is a binary relation on the set of alternatives.
def StrictPreferenceRelation := A → A → Prop

-- A profile of individual strict preferences assigns a strict preference relation to each individual.