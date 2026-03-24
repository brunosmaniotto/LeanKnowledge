import Mathlib

open scoped BigOperators
open Topology
open BigOperators

noncomputable section

variable {n : ℕ}

def supportFn (K : Set (Fin n → ℝ)) (p : Fin n → ℝ) : ℝ :=
  ⨅ z ∈ K, ∑ i, p i * z i