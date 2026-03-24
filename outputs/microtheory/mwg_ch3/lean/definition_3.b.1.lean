import Mathlib
open Topology

/-- A preference relation `r` on `X` is rational if it is complete and transitive.
    (MWG Definition 3.B.1, repeating Definition 1.B.1) -/
class RationalPreference (X : Type*) (r : X → X → Prop) : Prop where
  complete : ∀ x y : X, r x y ∨ r y x
  trans : ∀ x y z : X, r x y → r y z → r x z

instance {X : Type*} {r : X → X → Prop} [h : RationalPreference X r] : IsTotal X r :=
  ⟨h.complete⟩

instance {X : Type*} {r : X → X → Prop} [h : RationalPreference X r] : IsTrans X r :=
  ⟨h.trans⟩