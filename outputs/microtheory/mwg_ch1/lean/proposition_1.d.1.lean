import Mathlib

noncomputable section

attribute [local instance] Classical.propDecidable

-- Preference relation (reusing established structure from this codebase)
structure PrefRel (X : Type*) where
  rel : X → X → Prop

def PrefRel.IsRational {X : Type*} (R : PrefRel X) : Prop :=
  (∀ x y : X, R.rel x y ∨ R.rel y x) ∧
  (∀ x y z : X, R.rel x y → R.rel y z → R.rel x z)

-- C*(B, ≿) = {x ∈ B | ∀ y ∈ B, x ≿ y}