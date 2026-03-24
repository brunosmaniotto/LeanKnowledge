import Mathlib

open Function Relation

variable {X : Type*} [PartialOrder X]
variable {I : Type*} [Nonempty I]

/--
Definition of strict preference derived from a weak preference relation `weak_pref`.
`StrictPreference weak_pref x y` holds if `x` is weakly preferred to `y`, and `y` is not weakly preferred to `x`.
-/
def StrictPreference (weak_pref : X → X → Prop) (x y : X) : Prop :=
  weak_pref x y ∧ ¬weak_pref y x