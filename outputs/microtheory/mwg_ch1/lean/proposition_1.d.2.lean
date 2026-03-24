import Mathlib

variable {X : Type*} [DecidableEq X] [Fintype X]

def revealedPref (ℬ : Set (Finset X)) (C : Finset X → Finset X) (x y : X) : Prop :=
  ∃ B ∈ ℬ, x ∈ B ∧ y ∈ B ∧ x ∈ C B