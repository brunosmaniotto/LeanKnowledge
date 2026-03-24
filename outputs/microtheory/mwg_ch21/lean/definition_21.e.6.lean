import Mathlib

structure TakesToTop
    {X : Type*} [Fintype X] [DecidableEq X]
    (X' : Finset X)
    (I : Type*)
    (pref : I → X → X → Prop)
    (pref' : I → X → X → Prop) : Prop where
  top : ∀ i : I, ∀ x y : X, x ∈ X' → y ∉ X' → pref' i x y
  preserve : ∀ i : I, ∀ x y : X, x ∈ X' → y ∈ X' → (pref i x y ↔ pref' i x y)