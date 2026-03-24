import Mathlib

/-- An allocation function specifies, for each vector of individual types,
    a social state in `X`. Given `I` individuals where individual `i` has
    type space `T i`, an allocation function maps type profiles to outcomes. -/
abbrev AllocationFunction (I : Type*) (T : I → Type*) (X : Type*) :=
  (∀ i, T i) → X