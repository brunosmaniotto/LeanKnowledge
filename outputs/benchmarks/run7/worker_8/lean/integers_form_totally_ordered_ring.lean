import Mathlib

def IsTotallyOrderedRing (R : Type*) [CommRing R] [LinearOrder R] : Prop :=
  (∀ a b c : R, a ≤ b → a + c ≤ b + c) ∧
  (∀ a b : R, 0 ≤ a ∧ 0 ≤ b → 0 ≤ a * b)