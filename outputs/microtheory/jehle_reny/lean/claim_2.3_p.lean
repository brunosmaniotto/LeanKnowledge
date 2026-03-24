import Mathlib

noncomputable section

open Finset BigOperators Set
open Topology
open BigOperators

def dotProd {d : ℕ} (a b : Fin d → ℝ) : ℝ :=
  ∑ k : Fin d, a k * b k