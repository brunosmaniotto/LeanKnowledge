import Mathlib

/-- The strict social preference relation derived from a social welfare functional.
    Given a SWF `F` that maps preference profiles to a social preference relation,
    `F_p` returns the strict (asymmetric) part: x is socially preferred to y
    iff x is socially at least as good as y, but not vice versa. -/
def socialStrictPreference {X : Type*} {I : Type*}
    (F : (I → X → X → Prop) → (X → X → Prop))
    (profile : I → X → X → Prop) (x y : X) : Prop :=
  F profile x y ∧ ¬ F profile y x