import Mathlib
open Topology

/-- A utility possibility set for a coalition S is a nonempty, closed, comprehensive subset of ℝ^S.
    Comprehensive means: if uS ∈ carrier and u'S ≤ uS pointwise, then u'S ∈ carrier.
    This captures the "free disposability of utility" property. -/
structure UtilityPossibilitySet (S : Type*) [Fintype S] where
  carrier : Set (S → ℝ)
  nonempty' : carrier.Nonempty
  isClosed' : IsClosed carrier
  comprehensive' : ∀ x ∈ carrier, ∀ y : S → ℝ, (∀ s, y s ≤ x s) → y ∈ carrier