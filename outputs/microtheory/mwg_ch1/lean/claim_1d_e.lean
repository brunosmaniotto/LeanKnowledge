import Mathlib

universe u

variable {X : Type u}

structure ChoiceFn (X : Type u) where
  C : Finset X → Finset X

def WARP (cf : ChoiceFn X) : Prop :=
  ∀ B B' : Finset X, ∀ x y : X,
    x ∈ cf.C B → y ∈ B → x ∈ B' → y ∈ cf.C B' → x ∈ cf.C B'