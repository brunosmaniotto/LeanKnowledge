import Mathlib
open Topology
open BigOperators

/-- A behavioural strategy for a player in an extensive form game assigns
    to each of the player's information sets a probability distribution
    over the actions available at that information set.
    That is, `b h` is a PMF on `Action h` satisfying `b h a ∈ [0,1]`
    and `∑ a, b h a = 1` for every information set `h`. -/
def BehaviouralStrategy
    (InfoSet : Type*) (Action : InfoSet → Type*) :=
  (h : InfoSet) → PMF (Action h)