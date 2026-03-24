import Mathlib

/-- A social choice function on a finite set `X` of social states with individuals
    indexed by `I`. Under unrestricted domain, it maps every profile of individual
    preference relations to a chosen social state, and is surjective (every state
    in X is chosen under some profile). -/
structure SocialChoiceFunction (I : Type*) (X : Type*) [Fintype X] where
  choice : (I → X → X → Prop) → X
  surjective : Function.Surjective choice