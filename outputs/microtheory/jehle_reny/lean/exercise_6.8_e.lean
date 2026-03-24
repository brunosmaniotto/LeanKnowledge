import Mathlib
open Finset
set_option linter.unusedVariables false

variable {N : Type*} [Fintype N] [Nonempty N]

def const (a : ℝ) : N → ℝ := fun _ => a

noncomputable def min (u : N → ℝ) : ℝ :=
  Finset.inf' Finset.univ Finset.univ_nonempty u