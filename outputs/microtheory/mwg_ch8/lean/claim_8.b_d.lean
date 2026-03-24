import Mathlib
open Topology

variable {I : Type*} [DecidableEq I] {S : I → Type*}

def StrictlyDominates (u : (∀ i, S i) → I → ℝ) (player : I) (si si' : S player) : Prop :=
  ∀ (s : ∀ i, S i), u (Function.update s player si) player > u (Function.update s player si') player