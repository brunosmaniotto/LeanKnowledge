import Mathlib
open Topology

/-- An oligarchy social welfare functional: given a set of agents `I`, a set of alternatives `X`,
    and an oligarchy subset `S ⊆ I`, the social preference `x ≿ y` holds iff every member
    of the oligarchy weakly prefers `x` to `y`. -/
def oligarchySWF {I X : Type*} (S : Set I) (prefs : I → X → X → Prop) (x y : X) : Prop :=
  ∀ h ∈ S, prefs h x y