import Mathlib

def choiceStar {X : Type*} (B : Set X) (pref : X → X → Prop) : Set X :=
  {x ∈ B | ∀ y ∈ B, pref x y}