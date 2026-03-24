import Mathlib

open Set
open Topology

/-- S ⊂ T (S is a subset of T) iff every element of S is also an element of T.
    This is exactly Mathlib's `Set.Subset`: `∀ x, x ∈ S → x ∈ T`. -/
abbrev Implicit_Def_A1_2_1_b {α : Type*} (S T : Set α) : Prop :=
  S ⊆ T