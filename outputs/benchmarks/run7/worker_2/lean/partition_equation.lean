import Mathlib

open MulAction Fintype
open scoped BigOperators Classical

/-- The **Partition Equation** for a group action on a finite set. The cardinality of the set
is the sum of the cardinalities of the orbits. This is also known as the Orbit-Stabilizer Theorem
in a different form, or as Burnside's Lemma's foundation. -/
theorem PartitionEquation (G X : Type*) [Group G] [MulAction G X] [Fintype X] :
    card X = ∑ ω : Quotient (orbitRel G X), card (orbit G ω.out) := by
  rw [card_congr (selfEquivSigmaOrbits G X), card_sigma]