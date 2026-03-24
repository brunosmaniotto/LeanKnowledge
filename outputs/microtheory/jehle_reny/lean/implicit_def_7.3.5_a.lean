import Mathlib
open Topology

variable {A : Type*}

def StrictlyFollows (x y : List A) : Prop :=
  ∃ s : List A, s ≠ [] ∧ y = x ++ s