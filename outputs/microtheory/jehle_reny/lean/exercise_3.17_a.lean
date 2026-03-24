import Mathlib

open Finset BigOperators Real Filter Topology
open Topology
open BigOperators

noncomputable section

def cesProd {n : ℕ} (α x : Fin n → ℝ) (ρ : ℝ) : ℝ :=
  (∑ i : Fin n, α i * (x i) ^ ρ) ^ (1 / ρ)