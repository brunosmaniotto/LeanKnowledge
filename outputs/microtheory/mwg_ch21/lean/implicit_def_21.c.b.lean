import Mathlib

/-- A rational preference relation (complete preorder) on X. -/
structure RationalPreference (X : Type*) where
  rel : X → X → Prop
  complete : ∀ x y, rel x y ∨ rel y x
  trans : ∀ x y z, rel x y → rel y z → rel x z

/-- A strict preference: rational preference where no two distinct alternatives are indifferent.
    This means the relation is antisymmetric: if x ≽ y and y ≽ x then x = y. -/
structure StrictPreference (X : Type*) extends RationalPreference X where
  antisym : ∀ x y, rel x y → rel y x → x = y

/-- Every strict preference is a rational preference (P ⊂ R). -/
def StrictPreference.toRational {X : Type*} (P : StrictPreference X) : RationalPreference X :=
  P.toRationalPreference