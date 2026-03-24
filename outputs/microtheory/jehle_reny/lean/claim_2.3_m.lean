import Mathlib

variable {X : Type*}

def DirectRP (B : Set (Set X)) (C : Set X → Set X) (x y : X) : Prop :=
  ∃ S ∈ B, x ∈ C S ∧ y ∈ S