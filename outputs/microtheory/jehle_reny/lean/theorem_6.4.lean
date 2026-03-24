import Mathlib

open Fintype Function
open scoped Classical

variable {I X : Type*} [Fintype I] [Fintype X] [DecidableEq X]

-- Strict preference relation derived from a weak preference relation R_i
def strict_preference (R_i : X → X → Prop) (x y : X) : Prop := (R_i x y) ∧ ¬ (R_i y x)

-- Profile of individual preferences