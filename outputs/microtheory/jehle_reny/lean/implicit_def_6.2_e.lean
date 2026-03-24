import Mathlib

/-- An individual `i` is a dictator with respect to a social welfare function `W`
    if whenever `i` strictly prefers `x` over `y` (i.e., `x P_i y`),
    the social ordering also strictly prefers `x` over `y`,
    regardless of all other individuals' preferences. -/
def IsDictator {I X : Type*} [DecidableEq I]
    (W : (I → X → X → Prop) → X → X → Prop)
    (i : I) : Prop :=
  ∀ (profile : I → X → X → Prop) (x y : X),
    profile i x y → ¬ profile i y x →
    W profile x y ∧ ¬ W profile y x