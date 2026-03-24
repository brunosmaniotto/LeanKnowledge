import Mathlib

noncomputable section

open Finset BigOperators
open Topology
open BigOperators

variable {n : ℕ}

def pdot (p x : Fin n → ℝ) : ℝ := ∑ i, p i * x i