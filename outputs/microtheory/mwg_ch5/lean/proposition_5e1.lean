import Mathlib

open Finset BigOperators
open Topology
open BigOperators

noncomputable section

variable {n J : ℕ}

def firmProfit (Y : Set (Fin n → ℝ)) (p : Fin n → ℝ) : ℝ :=
  sSup ((fun y => ∑ l, p l * y l) '' Y)