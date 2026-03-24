import Mathlib
open Topology

/-- An individual `n` is a **dictator for social state `x`** under a social welfare
    functional `F` if, whenever `n` ranks `x` at least as good as every other
    alternative, the social ordering produced by `F` also ranks `x` at least as
    good as every other alternative. -/
def IsDictatorForState {I X : Type*}
    (F : (I → X → X → Prop) → X → X → Prop)
    (n : I) (x : X) : Prop :=
  ∀ (profile : I → X → X → Prop),
    (∀ y : X, profile n x y) → (∀ y : X, F profile x y)