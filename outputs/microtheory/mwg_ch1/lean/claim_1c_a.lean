import Mathlib

-- We work with a three-element type
inductive Alt : Type where
  | x | y | z
  deriving DecidableEq, Fintype

open Alt Finset

-- A choice function maps nonempty subsets to nonempty subsets of themselves
structure ChoiceFn where
  C : Finset Alt → Finset Alt
  subset : ∀ S, C S ⊆ S
  nonempty : ∀ S, S.Nonempty → (C S).Nonempty

-- The Weak Axiom of Revealed Preference:
-- If x, y ∈ S, x ∈ C(S), and y ∈ C(S'), x ∈ S' → x ∈ C(S')
-- Equivalently: if x is revealed preferred to y (x chosen when y available),
-- then y cannot be chosen without x in any set containing both.
def WARP (cf : ChoiceFn) : Prop :=
  ∀ (S T : Finset Alt) (a b : Alt),
    a ∈ S → b ∈ S → a ∈ cf.C S → b ∉ cf.C S →
    b ∈ T → a ∈ T → b ∈ cf.C T → a ∈ cf.C T

-- The key sets