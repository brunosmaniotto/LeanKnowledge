import Mathlib
open Function Finset
open Classical -- For decidability of propositions

-- A preference relation is a binary relation on alternatives (x R y means x is weakly preferred to y)
def Preference (X : Type) := X → X → Prop

-- A profile is a mapping from each agent to their preference relation.