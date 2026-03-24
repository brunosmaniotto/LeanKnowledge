import Mathlib

/-- The strict preference relation ≻ derived from a weak preference relation ≿.
    x ≻ y iff x ≿ y and ¬(y ≿ x). -/
def StrictPreference {X : Type*} (weak_pref : X → X → Prop) (x y : X) : Prop :=
  weak_pref x y ∧ ¬ weak_pref y x