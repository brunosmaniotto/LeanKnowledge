import Mathlib

noncomputable section

open Finset BigOperators
open Topology
open BigOperators

def profitFn {n : ℕ} (Y : Set (Fin n → ℝ)) (p : Fin n → ℝ) : ℝ :=
  sSup {v : ℝ | ∃ y ∈ Y, v = ∑ i, p i * y i}