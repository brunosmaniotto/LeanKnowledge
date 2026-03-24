import Mathlib

open Finset BigOperators
open Classical

variable {X I : Type*} [Fintype X] [Fintype I] [DecidableEq X] [DecidableEq I]
variable (P : I → X → X → Prop)
variable [∀ i, DecidableRel (P i)]
variable [∀ i, IsStrictTotalOrder X (P i)]

def borda_score_individual (i : I) (x : X) : ℕ :=
  (Finset.univ.filter (P i x)).card