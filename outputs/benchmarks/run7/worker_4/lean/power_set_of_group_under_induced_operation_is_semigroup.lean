import Mathlib

variable (G : Type*) [Group G]

/-- The power set of a group forms a semigroup under the induced set multiplication. -/
instance : Semigroup (Set G) :=
  Set.semigroup