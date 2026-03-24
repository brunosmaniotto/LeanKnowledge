import Mathlib

/-- For a function f : D → R and a set B ⊂ D, the image f(B) = {f(x) | x ∈ B}. -/
abbrev MWG.imageOfSubset {D R : Type*} (f : D → R) (B : Set D) : Set R :=
  f '' B