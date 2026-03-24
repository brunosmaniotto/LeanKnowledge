import Mathlib
open Topology

/-- A price function is fully revealing if whenever two states are distinguishable
    by some consumer's signal, they are also distinguishable by the price function. -/
def IsFullyRevealingPrice
    {S : Type*} {I : Type*} {P : Type*} {Signal : Type*}
    (pHat : S → P) (sigma : I → S → Signal) : Prop :=
  ∀ s s' : S, (∃ i : I, sigma i s ≠ sigma i s') → pHat s ≠ pHat s'