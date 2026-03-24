import Mathlib

/-- The indifference relation derived from a preference relation.
    `x ~ y` iff `x ≿ y` and `y ≿ x`. -/
def Indifferent {X : Type*} (pref : X → X → Prop) (x y : X) : Prop :=
  pref x y ∧ pref y x