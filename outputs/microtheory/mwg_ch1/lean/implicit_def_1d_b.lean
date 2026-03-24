import Mathlib

def RationalChoiceSet {X : Type*} (pref : X → X → Prop) (B : Set X) : Set X :=
  {x ∈ B | ∀ y ∈ B, pref x y}