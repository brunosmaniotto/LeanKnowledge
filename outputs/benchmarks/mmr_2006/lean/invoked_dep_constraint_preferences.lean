import Mathlib

noncomputable section
open Finset BigOperators
open Topology
open BigOperators

variable {S : Type*} [Fintype S] [DecidableEq S]

def relEntropy' (p q : S → ℝ) : ℝ :=
  ∑ s : S, p s * Real.log (p s / q s)