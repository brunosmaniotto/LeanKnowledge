import Mathlib

/-- A preference profile assigns a preference relation to each individual. -/
abbrev PreferenceProfile (I : Type*) (X : Type*) :=
  I → X → X → Prop

/-- A social choice function on domain `A` maps each preference profile in `A`
    to a chosen alternative in `X`. -/
abbrev SocialChoiceFunction (I : Type*) (X : Type*) (A : Set (PreferenceProfile I X)) :=
  ↥A → X