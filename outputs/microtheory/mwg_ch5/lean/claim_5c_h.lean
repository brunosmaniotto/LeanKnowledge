import Mathlib

open Set Finset BigOperators
open Topology
open BigOperators

noncomputable section

variable {n : ℕ} [NeZero n]

def dotProd (p y : Fin n → ℝ) : ℝ := ∑ i ∈ univ, p i * y i