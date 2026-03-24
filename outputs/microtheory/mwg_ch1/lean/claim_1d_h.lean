import Mathlib

universe u

def Rationalizes {X : Type u} (R : X → X → Prop) (C : Finset X → Finset X) (ℬ : Set (Finset X)) : Prop :=
  ∀ B ∈ ℬ, ∀ x ∈ B, (x ∈ C B ↔ ∀ y ∈ B, R x y)