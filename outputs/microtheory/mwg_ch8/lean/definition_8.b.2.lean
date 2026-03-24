import Mathlib
open Topology

def StrictlyDominates {I : Type*} [DecidableEq I] {S : I → Type*}
    (i : I) (u : (∀ j, S j) → ℝ) (s'_i s_i : S i) : Prop :=
  ∀ s : (∀ j, S j), u (Function.update s i s'_i) > u (Function.update s i s_i)