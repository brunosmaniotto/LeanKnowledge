import Mathlib
open Topology

variable {Action Signal Theta : Type*}
  [Fintype Action] [Fintype Signal] [Fintype Theta]
  [Nonempty Signal]

def IsStrictlyDominated (u : Action → Signal → Theta → ℝ) (a : Action) (θ : Theta) : Prop :=
  ∃ a' : Action, (Finset.univ.inf' Finset.univ_nonempty fun s => u a' s θ) > (Finset.univ.sup' Finset.univ_nonempty fun s => u a s θ)