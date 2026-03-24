import Mathlib

variable {X : Type*}

def StrictPreference (weakPref : X → X → Prop) (x y : X) : Prop :=
  weakPref x y ∧ ¬weakPref y x