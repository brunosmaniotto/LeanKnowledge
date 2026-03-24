import Mathlib

variable (S : Type u) [CommMonoid S] (C : Submonoid S)

instance : CommSemigroup (Localization C) := by
  infer_instance