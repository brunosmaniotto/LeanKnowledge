import Mathlib
open Topology

/-- Non-Dictatorship (Arrow's Condition D, Assumption 6.1):
    There is no individual i such that for all profiles and all x, y,
    x Pᵢ y implies x P y. -/
def NonDictatorship {I X : Type*}
    (F : (I → X → X → Prop) → (X → X → Prop)) : Prop :=
  ¬∃ i : I, ∀ (R : I → X → X → Prop) (x y : X),
    (R i x y ∧ ¬R i y x) → (F R x y ∧ ¬F R y x)