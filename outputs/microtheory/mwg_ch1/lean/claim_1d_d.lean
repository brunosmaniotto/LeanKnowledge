import Mathlib

def WARP {X : Type*} [DecidableEq X]
    (B_family : Set (Set X)) (C : Set X → X) : Prop :=
  ∀ B, B ∈ B_family → ∀ B', B' ∈ B_family →
    C B ∈ B' → C B' ∈ B → C B = C B'