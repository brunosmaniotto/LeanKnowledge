import Mathlib
open Set Filter Topology
open BigOperators
open Topology

noncomputable section

variable {n : ℕ} (p_bar : Fin n → ℝ) (u : ℝ × (Fin n → ℝ) → ℝ)

def budget_set (m : ℝ) : Set (Fin n → ℝ) :=
  {x | (∀ i, 0 ≤ x i) ∧ ∑ i, p_bar i * x i ≤ m}