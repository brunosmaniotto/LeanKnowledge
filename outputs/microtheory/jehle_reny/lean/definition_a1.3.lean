import Mathlib

def IsTransitiveRelation {S : Type*} (R : S → S → Prop) : Prop :=
  ∀ x y z : S, R x y → R y z → R x z