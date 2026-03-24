import Mathlib

-- Basic types for social choice theory
universe u
variable {I X : Type u} [Nonempty I] [Nonempty X] [DecidableEq X]

-- A binary relation representing individual preferences
def PreferenceRelation := X → X → Prop

-- A profile of preferences, one for each individual