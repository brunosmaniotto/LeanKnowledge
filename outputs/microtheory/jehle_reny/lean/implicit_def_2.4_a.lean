import Mathlib
open Topology

/-- A finite set of deterministic outcomes A = {a_1, ..., a_n},
    where each outcome involves no uncertainty. -/
structure FiniteOutcomeSet where
  /-- The type of outcomes -/
  Outcome : Type*
  /-- The outcome set is finite -/
  [fintype : Fintype Outcome]
  /-- There is at least one outcome (n ≥ 1) -/
  [nonempty : Nonempty Outcome]

instance (A : FiniteOutcomeSet) : Fintype A.Outcome := A.fintype
instance (A : FiniteOutcomeSet) : Nonempty A.Outcome := A.nonempty

/-- The number of outcomes n = |A|. -/
def FiniteOutcomeSet.card (A : FiniteOutcomeSet) : ℕ :=
  Fintype.card A.Outcome