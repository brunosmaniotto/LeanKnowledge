import Mathlib

universe u

variable {X : Type u}

structure RationalPreference (X : Type u) where
  pref : X → X → Prop
  complete : ∀ x y : X, pref x y ∨ pref y x
  trans : ∀ x y z : X, pref x y → pref y z → pref x z

namespace RationalPreference

variable (R : RationalPreference X)

def strictPref (x y : X) : Prop := R.pref x y ∧ ¬R.pref y x