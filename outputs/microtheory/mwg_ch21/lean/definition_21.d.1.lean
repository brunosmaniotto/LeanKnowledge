import Mathlib

structure PreferenceRelation (X : Type*) where
  pref : X → X → Prop
  refl : ∀ x, pref x x
  complete : ∀ x y, pref x y ∨ pref y x

namespace PreferenceRelation

variable {X : Type*}

def strictPref (R : PreferenceRelation X) (x y : X) : Prop :=
  R.pref x y ∧ ¬R.pref y x