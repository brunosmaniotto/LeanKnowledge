import Mathlib

/-- A function f : D → R is one-to-one (injective) if every point in the range
    is assigned to at most a single point in the domain. -/
abbrev MWG.IsInjective {D R : Type*} (f : D → R) : Prop := Function.Injective f

/-- A function f : D → R is onto (surjective) if every point in R is mapped to
    by some point in D. -/
abbrev MWG.IsSurjective {D R : Type*} (f : D → R) : Prop := Function.Surjective f