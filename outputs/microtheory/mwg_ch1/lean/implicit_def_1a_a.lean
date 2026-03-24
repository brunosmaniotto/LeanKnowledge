import Mathlib

/-- A set of mutually exclusive alternatives from which an individual must choose. -/
structure Alternatives where
  /-- The underlying type of alternatives. -/
  carrier : Type*
  /-- The set is nonempty (there must be something to choose from). -/
  nonempty : Nonempty carrier