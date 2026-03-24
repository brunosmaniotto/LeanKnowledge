import Mathlib

/-- A social welfare function maps an N-tuple of individual preference relations
    on `X` (one per agent in `I`) into a single social preference relation on `X`.
    That is, `R = f(R₁, …, Rₙ)` where each `Rᵢ` and `R` are binary relations on `X`. -/
abbrev SocialWelfareFunction (X : Type*) (I : Type*) :=
  (I → (X → X → Prop)) → (X → X → Prop)