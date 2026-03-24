import Mathlib
open Topology

/-- Unrestricted Domain (Arrow's Condition U): the domain `A` of a social
    welfare function includes every possible profile of individual preference
    relations on `X`.  That is, no preference profile is excluded. -/
def UnrestrictedDomain {I : Type*} {X : Type*}
    (A : Set (I → X → X → Prop)) : Prop :=
  A = Set.univ