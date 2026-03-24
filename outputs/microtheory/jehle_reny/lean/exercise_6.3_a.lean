import Mathlib
open Topology

variable {A I : Type*} [Fintype A] [DecidableEq A] [Fintype I] [Nonempty I]

/-- The social welfare function for an individual dictator `d`.
    Society prefers `a` over `b` if and only if individual `d` prefers `a` over `b`. -/
def lt_soc_dictator (d : I) (profile : I → A → A → Prop) (a b : A) : Prop :=
  profile d a b