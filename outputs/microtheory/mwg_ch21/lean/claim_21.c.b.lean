import Mathlib

open Finset BigOperators
open BigOperators

variable {X : Type*} [Fintype X] [DecidableEq X]
variable {I : Type*} [Fintype I] [DecidableEq I]

noncomputable def bordaScore (c : I → X → ℤ) (x : X) : ℤ :=
  ∑ i : I, c i x

def bordaPref (c : I → X → ℤ) (x y : X) : Prop :=
  bordaScore c x ≤ bordaScore c y