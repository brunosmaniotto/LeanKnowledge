import Mathlib

/-- A finite outcome space C with N outcomes, indexed 1 to N.
    Captures the assumption from MWG Section 6.B that the number
    of possible outcomes is finite. -/
structure FiniteOutcomeSpace where
  /-- The type of outcomes -/
  C : Type*
  /-- C is finite -/
  [finC : Fintype C]
  /-- The number of outcomes -/
  N : ℕ
  /-- N equals the cardinality of C -/
  card_eq : Fintype.card C = N
  /-- There is at least one outcome -/
  pos : N > 0

attribute [instance] FiniteOutcomeSpace.finC