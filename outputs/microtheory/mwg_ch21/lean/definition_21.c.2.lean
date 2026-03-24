import Mathlib
open Topology

/-- A social welfare functional F is Paretian if whenever every individual strictly prefers
    x to y (i.e., prefers x to y but not y to x), the social ordering also strictly prefers
    x to y. Here F maps preference profiles (each individual's binary relation on X) to a
    social binary relation on X. -/
structure IsParetian
    {X : Type*} {I : Type*}
    (F : (I → X → X → Prop) → (X → X → Prop)) : Prop where
  pareto : ∀ (profile : I → X → X → Prop) (x y : X),
    (∀ i : I, profile i x y ∧ ¬ profile i y x) →
    (F profile x y ∧ ¬ F profile y x)