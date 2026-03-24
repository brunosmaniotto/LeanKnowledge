import Mathlib

variable {X : Type*}

def indifferenceSet (pref : X → X → Prop) (x : X) : Set X :=
  {y | pref y x ∧ pref x y}